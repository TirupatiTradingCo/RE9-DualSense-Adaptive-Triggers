-- DualSense Adaptive Triggers for Resident Evil Requiem
-- Tracks weapon type and ammo, sends data to DSX via UDP

local udp = require("socket").udp()
local udp_client = udp()
local connected = false

-- Weapon resistance values (sent to DSX)
local WEAPON_PROFILES = {
    -- Pistols
    ["Item_Weapon_Handgun_M19"] = { resistance = 40, break_point = 80 },
    -- Shotguns
    ["Item_Weapon_Shotgun_W870"] = { resistance = 80, break_point = 95 },
    -- Magnums
    ["Item_Weapon_Magnum_K7"] = { resistance = 95, break_point = 98 },
    -- Rifles
    ["Item_Weapon_Rifle_CQBR"] = { resistance = 60, break_point = 85 },
    -- Special
    ["Item_Weapon_Rocket_Inf"] = { resistance = 100, break_point = 0 },
    -- Melee (no resistance)
    ["Item_Weapon_Knife"] = { resistance = 0, break_point = 0 }
}

-- Current weapon state
local current_weapon = nil
local current_ammo = 0
local weapon_resistance = 0
local weapon_break = 0

-- Connect to UDP client on startup
udp_client:setpeername("127.0.0.1", 26780)
udp_client:settimeout(0)

-- Helper to send trigger data to DSX
function send_trigger_update(resistance, break_point, ammo_remaining)
    local command = string.format("TRIGGER:%d:%d:%d", resistance, break_point, ammo_remaining)
    udp_client:send(command)
end

-- Hook into weapon change events
sdk.hook(
    sdk.find_type_definition("PlayerManager"):get_method("equip_weapon"),
    function(args)
        -- Called before weapon equip
    end,
    function(retval)
        -- Called after weapon equip
        local player = sdk.get_managed_singleton("PlayerManager")
        if player then
            current_weapon = player:call("get_current_weapon_id")
            if WEAPON_PROFILES[current_weapon] then
                weapon_resistance = WEAPON_PROFILES[current_weapon].resistance
                weapon_break = WEAPON_PROFILES[current_weapon].break_point
            else
                weapon_resistance = 0
                weapon_break = 0
            end
        end
    end
)

-- Track ammo changes
sdk.hook(
    sdk.find_type_definition("WeaponManager"):get_method("update_ammo"),
    function(args)
        -- Get current ammo before change
        local weapon = sdk.to_managed_object(args:get_argument(0))
        if weapon then
            current_ammo = weapon:get_field("current_ammo")
        end
    end,
    function(retval)
        -- Send updated trigger state
        if current_weapon and WEAPON_PROFILES[current_weapon] then
            -- If out of ammo, trigger goes limp
            if current_ammo <= 1 then
                send_trigger_update(0, 0, 0)
            else
                send_trigger_update(weapon_resistance, weapon_break, current_ammo)
            end
        end
    end
)

-- Menu for configuration
imgui.on_menu("DualSense Weapons", function()
    local enabled = true
    local changed, new_val = imgui.checkbox("Enable Adaptive Triggers", enabled)
    
    imgui.text("Current weapon: " .. (current_weapon or "none"))
    imgui.text("Resistance: " .. weapon_resistance)
    imgui.text("Break point: " .. weapon_break)
    imgui.text("Ammo: " .. current_ammo)
    
    if imgui.button("Test Shotgun") then
        send_trigger_update(80, 95, 5)
    end
    if imgui.button("Test Empty") then
        send_trigger_update(0, 0, 0)
    end
end)

log.info("DualSense Weapons loaded")