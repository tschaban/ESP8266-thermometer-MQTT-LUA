-- Configuration
--
-- LICENCE: http://opensource.org/licenses/MIT
-- 2016-10-11 tschaban https://github.com/tschaban

local module = {}

module.ID = node.chipid()

module.WIFI_SSID = "SSID"
module.WIFI_PASSWORD = "password"

module.MQTT_HOST = "mqtt.example.com"
module.MQTT_PORT = 1883
module.MQTT_USER = "user"
module.MQTT_PASSWORD = "password"
module.MQTT_TOPIC = "/sensor/"

module.INTERVAL = 5000

module.TEMP_SENSOR = 2
module.TEMP_CORRECTION = 0

module.SDA = 5 -- GPIO14 / D5
module.SCL = 6 -- GPIO12 / D6

return module

