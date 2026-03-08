local settings = require("settings")

local cal = sbar.add("item", {
    icon = {
        font = {
            family = settings.font.zh_cn,
            style = settings.font.style_map["Regular"],
            size = settings.font.size,
        },
        padding_left = 8,
    },
    label = {
        align = "right",
        font = {
            family = settings.font.zh_cn,
            style = settings.font.style_map["Regular"],
            size = settings.font.size,
        },
        padding_right = 10,
    },
    position = "right",
    update_freq = 30,
    padding_left = 1,
    padding_right = 1,
})



cal:subscribe({ "forced", "routine", "system_woke" }, function(env)
    local weeks = {"周日", "周一", "周二", "周三", "周四", "周五", "周六"}
    local t = os.date("*t")
    
    local icon_str = string.format("%d月%d日 %s", t.month, t.day, weeks[t.wday])
    
    local label_str = string.format("%02d:%02d", t.hour, t.min)

    cal:set({ icon = icon_str, label = label_str })
end)

-- Click to toggle Itsycal menu bar item
cal:subscribe("mouse.clicked", function(env)
    sbar.exec("osascript -e 'tell application \"System Events\" to tell process \"Itsycal\" to click menu bar item 1 of menu bar 2' &>/dev/null")
end)
