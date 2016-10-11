-- Configuration
--
-- LICENCE: http://opensource.org/licenses/MIT
-- 2016-10-11 tschaban https://github.com/tschaban


-- WiFi Configuration
wifiSSID = ""
wifiPassword = ""

-- MQTT Broker configuration
mqttBroker = ""
mqttPort = 1883
mqttUser = ""
mqttPass = ""

-- This parameter defines ID of a device. ID is used in MQTT topic
deviceID = "0"

-- Sensor
temperatureInterval = 5000
temperaturePIN = 2
currentTemperature = 0
temperatureCorrection = -2

-- LCD
sdaPIN = 5 -- GPIO14 / D5
sclPIN = 6 -- GPIO12 / D6

-- Script version
version = "0.2"