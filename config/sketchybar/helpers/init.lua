local home = os.getenv("HOME")
local lua_version = _VERSION:match("%d%.%d")

-- 动态路径配置
package.path = package.path .. ";" .. home .. "/.luarocks/share/lua/" .. lua_version .. "/?.lua;" .. home .. "/.luarocks/share/lua/" .. lua_version .. "/?/init.lua"
package.cpath = package.cpath .. ";" .. home .. "/.luarocks/lib/lua/" .. lua_version .. "/?.so"

-- 按需编译 C helpers (仅在没有二进制文件时执行，大幅提升重启速度)
local function check_and_compile()
    local helpers_dir = os.getenv("CONFIG_DIR") .. "/helpers"
    -- 简单检查一个关键二进制文件是否存在
    local f = io.open(helpers_dir .. "/event_providers/media_helper/bin/media_helper", "r")
    if f then
        f:close()
    else
        os.execute("(cd " .. helpers_dir .. " && make)")
    end
end

check_and_compile()
