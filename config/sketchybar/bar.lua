local colors = require("colors")

sbar.bar({
    height = 28,
    color = colors.bar.bg,
    border_color = colors.bar.border,
    border_width = 1,
    margin = 5,
    corner_radius = 9,
    shadow = true,
    sticky = true,
    padding_right = 8,
    padding_left = 8,
    topmost = "window",
    display = "all", -- Use 'all' or remove for global bar
})
