

local options = {
    --点按时快进秒数
    seek_distance = 5,

    --改变速度时的时间间隔
    speed_interval = 0.05,

    --每个时间间隔的速度变化
    speed_increase = 0.1,
    speed_decrease = 0.1,

    --加速的速度最大值
    speed_max = 3,
}

mp.options = require "mp.options"
mp.options.read_options(options, "pressing_faster")

local old_speed = nil
local is_repeating = false
local is_increasing = true

timer = mp.add_periodic_timer(options.speed_interval, function ()
    local cur_speed = mp.get_property_number("speed")
    if cur_speed == nil then
        return
    end

    if is_increasing then 
        if cur_speed < options.speed_max then
            local new_speed = math.min(cur_speed+options.speed_increase, options.speed_max)
            mp.set_property_number("speed", new_speed)
            return
        elseif cur_speed > options.speed_max then 
            mp.osd_message("你已经很快了!!!")
        end
        timer:kill()
        return
    end

    
    if cur_speed > old_speed then
        local new_speed = math.max(cur_speed-options.speed_decrease, old_speed)
        mp.set_property_number("speed", new_speed)
        return
    elseif cur_speed < old_speed then
        mp.osd_message("你太慢了!!!")
    end
    timer:kill()

end, true)


local function pressing_faster(key)
    -- key["event"]表示按键状态, 三个值为 up repeat down
    -- mp.osd_message(key["event"])
    if key["event"] == "down" then
        is_repeating = false
        return
    end

    if key["event"] == "repeat" then
        if not is_repeating then
            old_speed = mp.get_property_number("speed", 1.0)
            is_repeating = true
            -- 加速
            is_increasing = true
            timer:resume()
        end
        return
    end

    if key["event"] == "up" then
        -- 普通快进
        if not is_repeating then
            if options.seek_distance ~= 0 then
                mp.commandv("osd-msg-bar", "seek", options.seek_distance)
            end
            return
        end

        -- 减速
        is_increasing = false
        timer:resume()
    end

end

mp.add_forced_key_binding("RIGHT", "pressing_faster", pressing_faster, {complex = true})