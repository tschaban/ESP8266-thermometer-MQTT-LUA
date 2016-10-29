-- Startup script
--
-- LICENCE: http://opensource.org/licenses/MIT
-- 2016-10-11 tschaban https://github.com/tschaban


app = require("app")
config = require("config")
setup = require("setup")
lcd = require("lcd")
sensor = require("ds18b20")

setup.start()