-- Application
--
-- LICENCE: http://opensource.org/licenses/MIT
-- 2016-10-27 tschaban https://github.com/tschaban

local module = {}

currentTemperature = 0
counter = 0 -- Counter of requests
sent = 0 -- Counter how many times published to MQTT
m = nil


local function freeMemory()
    return node.heap() / 1024
end


-- get temp from a sesonr and publish to MQTT if changed
local function publish()
    counter = counter + 1

    lcd.display({
        "Temperature : " .. currentTemperature .. " " .. config.TEMP_UNIT,
        "Free mem  : " .. freeMemory() .. " KB",
        "Requested : " .. counter,
        "Published : " .. sent,
        "",
        "Processing..."
    })

    local s = sensor.readNumber(nil,config.TEMP_UNIT)
    local t = 0
    if s ~= nil then
        t = s + config.TEMP_CORRECTION
    end

    if currentTemperature ~= t then
        currentTemperature = t
        sent = sent + 1
        m:publish(config.MQTT_TOPIC .. config.ID .. "/temperature", t, 0, 0)
    end


    lcd.display({
        "Temperature : " .. currentTemperature .. " " .. config.TEMP_UNIT,
        "Free mem  : " .. freeMemory() .. " KB",
        "Requested : " .. counter,
        "Published : " .. sent,
        "",
        "Waiting..."
    })
end



local function mqttStart()

    lcd.display({
        "Booting",
        "Connecting to MQTT",
        "Broker: " .. config.MQTT_HOST,
        "ID: " .. config.ID,
        "",
        "Please wait..."
    })
    m = mqtt.Client("Sensor (ID=" .. config.ID .. ")", 180, config.MQTT_USER, config.MQTT_PASSWORD)

    m:lwt("/lwt", "Sensor " .. config.ID, 0, 0)

    m:on("offline", function(c)
        ip = wifi.sta.getip()
        tmr.alarm(2, 5000, 0, function()
            node.restart();
        end)
    end)

    m:connect(config.MQTT_HOST, config.MQTT_PORT, 0, function(c)
        tmr.alarm(1, config.INTERVAL, 1, function()
            publish()
        end)
    end)
end


function module.start()
    lcd.start()
    lcd.display({
        "Booting",
        "",
        "",
        "",
        "",
        "Please wait..."
    })
    sensor.setup(config.TEMP_SENSOR)
    mqttStart()
end

return module