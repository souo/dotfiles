local icons = require("icons")
local settings = require("settings")
local colors = require("colors")

-- 1. 根菜单项
local menu_root = sbar.add("item", "widgets.custom_menu", {
    position = "left",
    icon = {
        string = "󰓗",
        padding_left = 10,
        color = colors.accent,
    },
    label = { drawing = false },
    background = { color = colors.bg1, drawing = true },
    popup = { align = "left" }
})

-- 2. 视图切换逻辑
local function set_view(view)
    local is_main = (view == "main")
    local is_themes = (view == "themes")
    local is_prefs = (view == "prefs")

    sbar.set("/menu.main\\..*/", { drawing = is_main })
    sbar.set("/menu.themes\\..*/", { drawing = is_themes })
    sbar.set("/menu.prefs\\..*/", { drawing = is_prefs })
    sbar.set("menu.back", { drawing = not is_main })
end

-- 3. 创建通用返回按钮
local back_btn = sbar.add("item", "menu.back", {
    position = "popup." .. menu_root.name,
    drawing = false,
    icon = { string = "󰁝", padding_left = 5 },
    label = { string = "Back", font = { style = "Bold" } },
})
back_btn:subscribe("mouse.clicked", function() set_view("main") end)

-- 4. 创建【主菜单】项
local themes_cat = sbar.add("item", "menu.main.themes", {
    position = "popup." .. menu_root.name,
    icon = { string = "󰏘", padding_left = 5 },
    label = { string = "Themes      ›", font = { style = "Bold" } },
})
themes_cat:subscribe("mouse.clicked", function() set_view("themes") end)

local prefs_cat = sbar.add("item", "menu.main.prefs", {
    position = "popup." .. menu_root.name,
    icon = { string = "󰒓", padding_left = 5 },
    label = { string = "Preferences ›", font = { style = "Bold" } },
})
prefs_cat:subscribe("mouse.clicked", function() set_view("prefs") end)

-- 5. 创建【主题】子项
local theme_list = {
    { id = "mocha",     label = "Mocha" },
    { id = "oled",      label = "OLED Night" },
    { id = "cyberpunk", label = "Cyberpunk" },
    { id = "deep_sea",  label = "Deep Sea" },
    { id = "tokyo",     label = "Tokyo Night" },
    { id = "nord",      label = "Nordic Ice" },
}

for _, t in ipairs(theme_list) do
    sbar.add("item", "menu.themes." .. t.id, {
        position = "popup." .. menu_root.name,
        drawing = false,
        icon = { drawing = false },
        label = { string = "  " .. t.label },
    }):subscribe("mouse.clicked", function()
        local f = io.open(os.getenv("HOME") .. "/.sketchybar_theme", "w")
        if f then f:write(t.id) f:close() end
        sbar.exec("sketchybar --reload")
    end)
end

-- 6. 创建【首选项】子项 (Reload & Restart)
local reload_item = sbar.add("item", "menu.prefs.reload", {
    position = "popup." .. menu_root.name,
    drawing = false,
    icon = { string = "󰑐", padding_left = 5 },
    label = { string = "Reload Config" },
})
reload_item:subscribe("mouse.clicked", function() sbar.exec("sketchybar --reload") end)

-- 7. 全局交互
menu_root:subscribe("mouse.clicked", function()
    menu_root:set({ popup = { drawing = "toggle" } })
end)

menu_root:subscribe("mouse.exited.global", function()
    menu_root:set({ popup = { drawing = false } })
    set_view("main")
end)
