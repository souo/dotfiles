local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local ram = sbar.add("item", "widgets.ram", {
    position = "right",
    update_freq = 5,
    icon = {
        string = icons.memory,
        font = { family = settings.font_icon.text, size = settings.icon_size },
        padding_left = settings.padding.icon_label_item.icon.padding_left,
        padding_right = settings.padding.icon_label_item.icon.padding_right,
    },
    label = {
        font = { family = settings.font.numbers, style = "Bold", size = settings.label_size },
        padding_right = settings.padding.icon_label_item.label.padding_right,
    },
})

ram:subscribe({ "routine", "forced" }, function()
    sbar.exec("memory_pressure", function(output)
        local free = tonumber(output:match("Pages free:%s+(%d+)")) or 0
        local active = tonumber(output:match("Pages active:%s+(%d+)")) or 0
        local inactive = tonumber(output:match("Pages inactive:%s+(%d+)")) or 0
        local spec = tonumber(output:match("Pages speculative:%s+(%d+)")) or 0
        local wired = tonumber(output:match("Pages wired down:%s+(%d+)")) or 0
        local comp = tonumber(output:match("Pages occupied by compressor:%s+(%d+)")) or 0

        local total = free + active + inactive + spec + wired + comp
        if total == 0 then return end
        
        -- macOS 真实的已用内存公式
        local used = active + wired + comp
        local percent = math.floor((used / total) * 100)

        local color = colors.blue
        if percent > 85 then color = colors.red
        elseif percent > 70 then color = colors.orange
        elseif percent > 50 then color = colors.yellow
        end

        ram:set({
            icon = { color = color },
            label = { string = string.format("%02d%%", percent), color = color }
        })
    end)
end)

ram:subscribe("mouse.clicked", function()
    sbar.exec("open -a 'Activity Monitor'")
end)

sbar.add("bracket", "widgets.ram.bracket", { ram.name }, { background = { color = colors.bg1 } })
sbar.add("item", { position = "right", width = settings.group_paddings })
