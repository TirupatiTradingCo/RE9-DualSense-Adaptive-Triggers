-- DualSense LED Health Indicator for Resident Evil Requiem
-- Changes controller LED color based on player health

local udp = require("socket").udp()
local udp_client = udp()
udp_client:setpeername("127.0.0.1", 26780)

local player_manager = nil
local last_health = 100
local last_led_sent = ""

function get_player_health()
    player_manager = player_manager or sdk.get_managed_singleton("PlayerManager")
    if not player_manager then return 100 end
    
    local health = player_manager:call("get_health_percentage")
    return health * 100
end

function get_led_color_from_health(health)
    if health > 75 then
        return "GREEN"
    elseif health > 50 then
        return "YELLOW"
    elseif health > 25 then
        return "ORANGE"
    elseif health > 10 then
        return "RED"
    else
        return "RED_FLASH"
    end
end

function send_led_color(color)
    if color == last_led_sent then return end
    local command = string.format("LED:%s", color)
    udp_client:send(command)
    last_led_sent = color
end

-- Track healing events
sdk.hook(
    sdk.find_type_definition("PlayerManager"):get_method("use_healing_item"),
    function(args)
        -- Flash white when healing
        send_led_color("WHITE_FLASH")
    end,
    function(retval)
        -- Restore health-based color after heal
        local health = get_player_health()
        send_led_color(get_led_color_from_health(health))
    end
)

-- Periodic health check
re.on_frame(function()
    local health = get_player_health()
    if math.abs(health - last_health) > 5 then
        last_health = health
        send_led_color(get_led_color_from_health(health))
    end
end)

-- Menu
imgui.on_menu("DualSense LED", function()
    imgui.text("Current health: " .. string.format("%.1f%%", last_health))
    imgui.text("LED color: " .. last_led_sent)
    
    if imgui.button("Test Green") then send_led_color("GREEN") end
    imgui.same_line()
    if imgui.button("Test Yellow") then send_led_color("YELLOW") end
    imgui.same_line()
    if imgui.button("Test Red") then send_led_color("RED") end
    imgui.same_line()
    if imgui.button("Test Flash") then send_led_color("RED_FLASH") end
end)

log.info("DualSense LED loaded")