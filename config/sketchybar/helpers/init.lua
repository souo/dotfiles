-- Add the sketchybar module to the package cpath
package.cpath = package.cpath .. ";/Users/" .. os.getenv("USER") .. "/.local/share/sketchybar_lua/?.so"

-- Add luarocks paths for AeroSpaceLua dependencies
local lua_version = 5.5

package.path = package.path .. ";" .. os.getenv("HOME") .. "/.luarocks/share/lua/" .. lua_version .. "/?.lua" .. ";" .. os.getenv("HOME") .. "/.luarocks/share/lua/" .. lua_version .. "/?/init.lua"
package.cpath = package.cpath .. ";" .. os.getenv("HOME") .. "/.luarocks/lib/lua/" .. lua_version .. "/?.so"

os.execute("(cd helpers && make)")