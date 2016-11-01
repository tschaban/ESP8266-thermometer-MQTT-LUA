### This is thermometer implementation on ESP8266

**Features**
* Values are published to MQTT Broker. They can be consumed by other services eg home automation software like openHAB
* You can set how often ESP8266 reads temperature from the temp. sensor
* It publishes MQTT messages only if temperature has been changed
* You can set temperature unit to Celsius, Fahrenheit, Kelvin
* It's possible to correct temperature value returned by sensor by value specified in config file 

### Hardware
* ESP8266 (eg. Mini NodeMCU by WeMos 4MB)
* DS18B20 sensor
* 128X64 OLED LCD 0.96" I2C

**MQTT Topic** 

```
/sensor/ID/temperature
```

* it returns value in integer in unit defined in config file
* _ID_ can be set in the configuration file


### Configuration
Configuration should be made in _config.lua_ file

| Parameter  | Description |
|---|---|
| ID | Device ID. It's used in the MQTT Topic to distinguish other similar sensors in your MQTT Broker. You can change it. Use either numbers or chars. Don't use space or special characters, default is ESP8266 ChipID |
| WIFI_SSID  | WiFi network name |
| WIFI_PASSWORD   | WiFi network password |
| MQTT_HOST  | MQTT Broker IP or host name |
| MQTT_PORT  | MQTT Port, default 1883 |
| MQTT_USER  | MQTT User name, leave blank if there is no user authentication in your MQTT broker |
| MQTT_PASSWORD  | MQTT User name, leave blank if there is no user authentication in your MQTT broker |
| INTERVAL   | How often ESP8266 should get temperature value from the sensor, default 5000msec (5sec) |
| TEMP_SENSOR   | GPIO pin number  where sensor is connected to, default 2 |
| TEMP_CORRECTION   | Temperature will be corrected by the value set in this parameter, default 0 |
| TEMP_UNIT | Use to set unit of returned temperature. Celsius set to **C**, Kelvin set to **K**, Fahrenheit set to **F**, default Celsius |
| SDA   | LCD sda GPIO pin number |
| SCL   | LCD scl GPIO pin number |

**Installation**

Following files have to be compiled on ESP8266
* config.lua
* lcd.lua
* setup.lua
* app.lua
* ds18b20.lua


Below code does it and in addition removes lua files afterwards - they are no longer required after they are compiled
``` 
node.compile("config.lua")
node.compile("setup.lua")
node.compile("app.lua")
node.compile("lcd.lua")
node.compile("ds18b20.lua")
file.remove("config.lua")
file.remove("setup.lua")
file.remove("app.lua")
file.remove("lcd.lua")
file.remove("ds18b20.lua")
```

_init.lua_ should be uploaded to Sonoff as is - without compilation