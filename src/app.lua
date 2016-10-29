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
        "Temperature : " .. currentTemperature .. " C",
        "Free mem  : " .. freeMemory() .. " KB",
        "Requested : " .. counter,
        "",
        "",
        "Processing"})

    print("Reading sensor info")

    print("CORRECTION = " .. config.TEMP_CORRECTION)

    local s = sensor.readNumber()
    local t = 0
    if s ~= nil then
      t = s + config.TEMP_CORRECTION
    end

    print("Calculation")
    if currentTemperature ~= t then
        currentTemperature = t
        sent = sent + 1
        print("Publishing")
        m:publish(config.MQTT_TOPIC .. config.ID .. "/temperature", t, 0, 0)
    end


    lcd.display({
        "Temperature : " .. currentTemperature .. " C",
        "Free mem  : " .. freeMemory() .. " KB",
        "Requested : " .. counter,
        "",
        "",
        ""})
end



local function mqttStart()

    lcd.display({
        "Booting",
        "Connecting to MQTT",
        "- " .. config.MQTT_HOST,
        "",
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
    print("LCD")
    sensor.setup(config.TEMP_SENSOR)
    print("MQTT start")

    lcd.display({
        "Booting",
        "",
        "",
        "",
        "",
        "Please wait..."
    })

    mqttStart()
end

return module