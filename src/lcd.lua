-- LCD
--
-- LICENCE: http://opensource.org/licenses/MIT
-- 2016-10-27 tschaban https://github.com/tschaban

local module = {}

disp = nil

local function writeToLCD(l)
    disp:setFont(u8g.font_6x10)
    disp:drawStr(0, 10, l[1])
    disp:drawStr(2, 24, l[2])
    disp:drawStr(2, 34, l[3])
    disp:drawStr(2, 34, l[4])
    disp:setFont(u8g.font_chikita)
    disp:drawLine(0, 47, 128, 47)
    disp:drawStr(0, 55, l[5])
    disp:drawStr(0, 55, l[6])
end

function module.display(t)
    disp:firstPage()
    repeat
        writeToLCD(t)
    until disp:nextPage() == false
end

function module.start()
    i2c.setup(0, config.SDA, config.SCL, i2c.SLOW)
    disp = u8g.ssd1306_128x64_i2c(0x3c)
end

return module