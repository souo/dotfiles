-- Ultimate Safety Theme (Hardcoded Fallback)
local fallback_theme = {
    white       = 0xffcdd6f4,
    black       = 0xff1e1e2e,
    grey        = 0xff6c7086,
    red         = 0xfff38ba8,
    green       = 0xffa6e3a1,
    yellow      = 0xfff9e2af,
    blue        = 0xff89b4fa,
    orange      = 0xfffab387,
    magenta     = 0xffcba6f7,
    cyan        = 0xff94e2d5,
    bar         = { bg = 0xcc1e1e2e, border = 0x44bac2de },
    popup       = { bg = 0xff181825, border = 0xff313244 },
    bg1         = 0x33585b70,
    bg2         = 0x44585b70,
    accent      = 0xffb4befe,
}

local theme_file = os.getenv("HOME") .. "/.sketchybar_theme"
local config_dir = os.getenv("SKETCHYBAR_CONFIG_DIR") or (os.getenv("HOME") .. "/.dotfiles/config/sketchybar")

-- Helper: Load theme from absolute path
local function load_theme(name)
    if not name then return nil end
    local path = config_dir .. "/themes/" .. name .. ".lua"
    local chunk, err = loadfile(path)
    if not chunk then return nil end
    local ok, res = pcall(chunk)
    return ok and res or nil
end

-- Read active theme name
local function get_active_theme_name()
    local f = io.open(theme_file, "r")
    if not f then return "mocha" end

    local name = f:read("*l")
    f:close()

    if name then
        name = name:gsub("%s+", "")
        if name ~= "" then return name end
    end
    return "mocha"
end

local theme_name = get_active_theme_name()
local theme = load_theme(theme_name) or load_theme("mocha") or fallback_theme

-- Inject helper function
function theme.with_alpha(color, alpha)
    alpha = alpha or 1.0
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
end

return theme
