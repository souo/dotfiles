local settings = require("settings")
local colors = require("colors")

local MAX_ITEMS = 15
local menu_items = {}
local menu_visible = false

-- 1. 触发器图标
local menu_trigger = sbar.add("item", "menu.trigger", {
    position = "left",
    icon = { string = "≡", font = { size = 14.0 }, padding_left = 10, padding_right = 10 },
    label = { drawing = false },
    updates = true,
})

-- 2. 预创建菜单项 (池化)
for i = 1, MAX_ITEMS do
    menu_items[i] = sbar.add("item", "menu." .. i, {
        position = "left",
        drawing = false,
        width = 0,
        icon = { drawing = false },
        label = { font = { style = "Semibold" }, padding_left = 6, padding_right = 6 },
        click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s " .. i,
    })
end

local function update_menus()
    sbar.exec("$CONFIG_DIR/helpers/menus/bin/menus -l", function(output)
        local id = 1
        for line in output:gmatch("[^\r\n]+") do
            if id > MAX_ITEMS then break end
            menu_items[id]:set({ label = { string = line }, drawing = menu_visible, width = menu_visible and "dynamic" or 0 })
            id = id + 1
        end
        -- 隐藏多余的项
        for i = id, MAX_ITEMS do
            menu_items[i]:set({ drawing = false, width = 0 })
        end
    end)
end

local function toggle_menus()
    menu_visible = not menu_visible
    if menu_visible then
        update_menus()
        sbar.animate("tanh", 20, function()
            for i = 1, MAX_ITEMS do
                if menu_items[i]:query().label.value ~= "" then
                    menu_items[i]:set({ width = "dynamic" })
                end
            end
        end)
    else
        sbar.animate("tanh", 20, function()
            for i = 1, MAX_ITEMS do
                menu_items[i]:set({ width = 0 })
            end
        end)
    end
end

menu_trigger:subscribe("mouse.clicked", toggle_menus)
menu_trigger:subscribe("front_app_switched", function()
    if menu_visible then update_menus() end
end)

-- 初始加载一次但不显示
update_menus()
