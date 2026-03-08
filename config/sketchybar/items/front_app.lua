local settings = require("settings")
local colors = require("colors")

local front_app = sbar.add("item", "front_app", {
    position = "left",
    icon = { drawing = false },
    label = {
        font = { family = settings.font.text, style = "Bold", size = 12.0 },
        color = colors.white,
    },
    updates = "on",
})

front_app:subscribe("front_app_switched", function(env)
    sbar.animate("tanh", 10, function()
        front_app:set({ label = { string = env.INFO } })
    end)
end)

front_app:subscribe("mouse.clicked", function()
    sbar.trigger("swap_menus_and_spaces") -- 触发自定义全局动作
end)
