local settings = require("settings")
local colors = require("colors")

sbar.default({
    background = {
        border_color = colors.bg2,
        border_width = 1,
        color = colors.bg1,
        corner_radius = 6,
        height = settings.height,
    },
    icon = {
        font = {
            family = settings.font_icon.text,
            style = "Bold",
            size = settings.font_icon.size
        },
        color = colors.accent, -- Default icons to accent color
        highlight_color = colors.white,
    },
    label = {
        font = {
            family = settings.font.text,
            style = "Semibold",
            size = settings.font.size
        },
        color = colors.white, -- Default text to clean white for best contrast
        highlight_color = colors.accent,
    },
    popup = {
        align = "center",
        background = {
            border_width = 1,
            border_color = colors.popup.border,
            corner_radius = 9,
            color = colors.popup.bg,
            shadow = { drawing = true },
        },
        blur_radius = 20,
        y_offset = 7
    },
    padding_left = 3,
    padding_right = 3,
    scroll_texts = true,
    updates = "on",
    display = 1,
})
