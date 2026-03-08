local settings = require("settings")

local cal = sbar.add("item", "widgets.calendar", {
    position = "right",
    update_freq = 30,
    icon = {
        font = { family = settings.font.zh_cn, size = settings.font.size },
        padding_left = 8,
    },
    label = {
        font = { family = settings.font.numbers, size = settings.font.size },
        padding_right = 10,
    },
    padding_left = 1,
    padding_right = 1,
})

cal:subscribe({ "forced", "routine", "system_woke" }, function()
    local weeks = { "周日", "周一", "周二", "周三", "周四", "周五", "周六" }
    local t = os.date("*t")

    cal:set({
        icon = { string = string.format("%d月%d日 %s", t.month, t.day, weeks[t.wday]) },
        label = { string = string.format("%02d:%02d", t.hour, t.min) }
    })
end)

-- 点击唤起 Itsycal (如果安装了的话)
cal:subscribe("mouse.clicked", function()
    sbar.exec("osascript -e 'tell application \"System Events\" to tell process \"Itsycal\" to click menu bar item 1 of menu bar 2' &>/dev/null")
end)
