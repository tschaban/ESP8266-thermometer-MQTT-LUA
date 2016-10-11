This is thermometer implementation on ESP9266.
Values are published to MQTT Broker. It can be later consumed by other services eg home automation software like openHAB

MQTT Topic /sensor/DeviceID/temperature

where DeviceID can be set in the configuration file

**Hardware**
- ESP8266 (Mini NodeMCU by WeMos 4MB)
- DS18B20 sensor
- 128X64 OLED LCD 0.96" I2C

**Configuration**
Configuration should be made in config.lua file

| Parameter  | Description |
|---|---|
| wifiSSID  | WiFi network name |
| wifiPassword   | WiFi network password |
| mqttBroker  | MQTT Broker IP or host name |
| mqttPort  | MQTT Port, default 1883 |
| mqttUser  | MQTT User name, leave blank if there is no user authentication at your MQTT broker |
| mqttPass  | MQTT User name, leave blank if there is no user authentication at your MQTT broker |
| deviceID   | Enter any device ID, use either numbers or chars no space or special characters |
| temperatureInterval   | How often get temperature from the sensor, default 5000msec (5sec) |
| temperaturePIN   | PIN ID where sensor is connected to |
| temperatureCorrection   | Add any value if you want to correct sensor value |
| sdaPIN   | LCD sda PIN |
| sclPIN   | LCD scl PIN |


**Installation**

Following files have to be compiled on ESP8266
- config.lua
- main.lua
- ds18b20.lua
