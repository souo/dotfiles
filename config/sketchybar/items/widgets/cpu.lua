local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Cleanly start helper
sbar.exec("killall cpu_load >/dev/null 2>&1; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

local cpu = sbar.add("item", "widgets.cpu", {
    position = "right",
    icon = {
        string = icons.cpu,
        font = { family = settings.font_icon.text, size = settings.icon_size },
        padding_left = settings.padding.icon_label_item.icon.padding_left,
        padding_right = settings.padding.icon_label_item.icon.padding_right,
    },
    label = {
        string = "??%",
        font = { family = settings.font.numbers, style = "Bold", size = settings.label_size },
        padding_right = settings.padding.icon_label_item.label.padding_right,
    },
})

cpu:subscribe("cpu_update", function(env)
    local load = tonumber(env.total_load) or 0
    local color = colors.accent
    if load > 80 then color = colors.red
    elseif load > 60 then color = colors.orange
    elseif load > 30 then color = colors.yellow
    end

    cpu:set({
        icon = { color = color },
        label = { string = string.format("%02d%%", load) }
    })
end)

cpu:subscribe("mouse.clicked", function() sbar.exec("open -a 'Activity Monitor'") end)

sbar.add("bracket", "widgets.cpu.bracket", { cpu.name }, { background = { color = colors.bg1 } })
sbar.add("item", { position = "right", width = settings.group_paddings })
