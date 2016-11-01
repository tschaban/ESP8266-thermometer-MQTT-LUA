**This is thermometer implementation on ESP8266**
Values are published to MQTT Broker. It can be later consumed by other services eg home automation software like openHAB

MQTT Topic /sensor/ID/temperature

where ID can be set in the configuration file, default is ESP8266 ChipID

**Hardware**
- ESP8266 (Mini NodeMCU by WeMos 4MB)
- DS18B20 sensor
- 128X64 OLED LCD 0.96" I2C

**Configuration**
Configuration should be made in config.lua file

| Parameter  | Description |
|---|---|
| WIFI_SSID  | WiFi network name |
| WIFI_PASSWORD   | WiFi network password |
| MQTT_HOST  | MQTT Broker IP or host name |
| MQTT_PORT  | MQTT Port, default 1883 |
| MQTT_USER  | MQTT User name, leave blank if there is no user authentication at your MQTT broker |
| MQTT_PASSWORD  | MQTT User name, leave blank if there is no user authentication at your MQTT broker |
| ID | Device ID, use either numbers or chars no space or special characters, default is ChipID |
| INTERVAL   | How often get temperature from the sensor, default 5000msec (5sec) |
| TEMP_SENSOR   | PIN ID where sensor is connected to |
| TEMP_CORRECTION   | Add any value if you want to correct sensor value |
| SDA   | LCD sda PIN |
| SCL   | LCD scl PIN |

**Installation**

Following files have to be compiled on ESP8266
- config.lua
- lcd.lua
- setup.lua
- app.lua
- ds18b20.lua
