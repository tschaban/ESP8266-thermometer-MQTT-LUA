-- Main script
--
-- LICENCE: http://opensource.org/licenses/MIT
-- 2016-10-11 tschaban https://github.com/tschaban

-- Some control variables
counter = 0 -- Counter of requests
sent = 0    -- Counter how many times published to MQTT

-- setup I2c and connect display
function init_i2c_display()
    i2c.setup(0, sdaPIN, sclPIN, i2c.SLOW)
    disp = u8g.ssd1306_128x64_i2c(0x3c)
end

function writeToLCD(lcdHeader, lcdLine1, lcdLine2, lcdStatus)
    disp:setFont(u8g.font_6x10)
    disp:drawStr(0, 10, lcdHeader)
    disp:drawStr(2, 24, lcdLine1)
    disp:drawStr(2, 34, lcdLine2)
    if sent > 0 then
        disp:drawStr(2, 44, "Published : " .. sent)
    end
    disp:setFont(u8g.font_chikita)
    disp:drawLine(0, 47, 128, 47)
    disp:drawStr(0, 55, lcdStatus)
    if ip ~= nil then
        disp:drawStr(0, 64, "IP: " .. ip .. ", v" .. version .. ", ID: " .. deviceID)
    end
end

function display(lcdHeader, lcdLine1, lcdLine2, lcdStatus)
    disp:firstPage()
    repeat
        writeToLCD(lcdHeader, lcdLine1, lcdLine2, lcdStatus)
    until disp:nextPage() == false
end


-- Connecting to WiFi, never finishes
function connectWiFi()
    tmr.alarm(0, 5000, 1, function()
        display("Booting", "Connecting to WiFI", wifiSSID, "Connecting...")
        ip = wifi.sta.getip()
        if ((ip ~= nil) and (ip ~= "0.0.0.0")) then
            tmr.stop(0)
            main()
        else
            display("Booting", "Connecting to WiFI", wifiSSID, "Failed...")
        end
    end)
end

-- get free memory in KB
function freeMemory()
    return node.heap() / 1024
end

-- get temp from a sesonr and publish to MQTT if changed
function publish()
    counter = counter + 1
    display("Temperature : " .. currentTemperature .. " C", "Free mem  : " .. freeMemory() .. " KB", "Requested : " .. counter, "Processing")
    local t = sensor.readNumber() + temperatureCorrection
    if currentTemperature ~= t then
        currentTemperature = t
        sent = sent + 1
        m:publish("/sensor/" .. deviceID .. "/temperature", t, 0, 0)
    end
    display("Temperature : " .. currentTemperature .. " C", "Free mem  : " .. freeMemory() .. " KB", "Requested : " .. counter, "")
end


function main() -- core function
    sensor = require("ds18b20")
    sensor.setup(temperaturePIN)
    display("Booting", "Connecting to MQTT", "- " .. mqttBroker, "Please wait...")
    tmr.alarm(0, 1000, 1, function()
        if wifi.sta.status() == 5 and wifi.sta.getip() ~= nil then
            tmr.stop(0)
            -- Connecting to MQTT
            m = mqtt.Client("Sensor (ID=" .. deviceID .. ")", 180, mqttUser, mqttPass)
            m:lwt("/lwt", "Sensor " .. deviceID, 0, 0)
            m:on("offline", function(c)
                tmr.alarm(2, 5000, 0, function()
                    print("Restartinfg device: mqtt offline")
                    node.restart();
                end)
            end)
            m:connect(mqttBroker, mqttPort, 0, function(c)
                tmr.alarm(1, temperatureInterval, 1, function()
                    publish()
                end)
            end)
        else
            print("MQTT Connecting")
        end
    end)
end

init_i2c_display()

-- Connecting to WiFi
ip = wifi.sta.getip()
if ((ip == nil) or (ip == "0.0.0.0")) then
    display("Booting", "Connecting to WiFI", wifiSSID, "Please wait...")
    wifi.setmode(wifi.STATION)
    wifi.sta.config(wifiSSID, wifiPassword)
    connectWiFi()
else
    main() -- run main core function
end









