-- DualSense Gyro Aiming for Resident Evil Requiem
-- Enables motion controls for precise aiming

local udp = require("socket").udp()
local udp_client = udp()
udp_client:setpeername("127.0.0.1", 26780)

local gyro_enabled = true
local gyro_sensitivity = 1.0
local gyro_activation = "while_aiming" -- "always", "while_aiming", "touchpad"

function send_gyro_command(enabled, sens)
    local cmd = string.format("GYRO:%d:%f", enabled and 1 or 0, sens)
    udp_client:send(cmd)
end

-- Hook into aiming state
sdk.hook(
    sdk.find_type_definition("PlayerManager"):get_method("is_aiming"),
    function(args)
        -- Pre-hook
    end,
    function(retval)
        local is_aiming = retval:get_value() == 1
        if gyro_enabled then
            if gyro_activation == "while_aiming" then
                send_gyro_command(is_aiming, gyro_sensitivity)
            elseif gyro_activation == "always" then
                send_gyro_command(true, gyro_sensitivity)
            end
        end
    end
)

-- Menu
imgui.on_menu("DualSense Gyro", function()
    local changed, new_val = imgui.checkbox("Enable Gyro Aiming", gyro_enabled)
    if changed then
        gyro_enabled = new_val
        send_gyro_command(gyro_enabled, gyro_sensitivity)
    end
    
    if gyro_enabled then
        local sens_changed, new_sens = imgui.slider_float("Sensitivity", gyro_sensitivity, 0.1, 3.0)
        if sens_changed then
            gyro_sensitivity = new_sens
            send_gyro_command(gyro_enabled, gyro_sensitivity)
        end
        
        local modes = {"always", "while_aiming", "touchpad"}
        local current_idx = 1
        for i, mode in ipairs(modes) do
            if mode == gyro_activation then current_idx = i end
        end
        
        local mode_changed, new_idx = imgui.combo("Activation Mode", current_idx, "Always\0While Aiming\0Touchpad\0")
        if mode_changed then
            gyro_activation = modes[new_idx]
        end
    end
end)

log.info("DualSense Gyro loaded")