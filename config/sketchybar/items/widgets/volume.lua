local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local volume_percent = sbar.add("item", "widgets.volume1", {
    position = "right",
    icon = { drawing = false },
    label = {
        string = "??%",
        padding_left = -1,
        font = { family = settings.font.numbers, style = "Bold", size = settings.label_size },
    },
})

local volume_icon = sbar.add("item", "widgets.volume2", {
    position = "right",
    icon = {
        color = colors.white,
        font = { family = settings.font_icon.text, style = "Bold", size = settings.icon_size },
        string = icons.volume._100,
    },
    label = { drawing = false },
})

local volume_bracket = sbar.add("bracket", "widgets.volume.bracket", {
    volume_icon.name,
    volume_percent.name
}, {
    background = { color = colors.bg1 },
    popup = { align = "center" }
})

local volume_slider = sbar.add("slider", 160, {
    position = "popup." .. volume_bracket.name,
    slider = {
        highlight_color = colors.accent,
        background = { color = colors.bg2, height = 6, corner_radius = 3 },
        knob = { string = "󰝥", drawing = true },
    },
    background = { color = colors.bg1, height = 2, margin = 5, corner_radius = 9 },
    click_script = 'osascript -e "set volume output volume $PERCENTAGE"'
})

-- Timeout Logic
local TIMEOUT_SECONDS = 5
local timer = 0

local function reset_timer()
    timer = TIMEOUT_SECONDS
end

local function close_popup()
    timer = 0
    volume_bracket:set({ popup = { drawing = false } })
end

volume_percent:subscribe("volume_change", function(env)
    local volume = tonumber(env.INFO)
    local icon = icons.volume._0
    if volume > 60 then icon = icons.volume._100
    elseif volume > 30 then icon = icons.volume._66
    elseif volume > 10 then icon = icons.volume._33
    elseif volume > 0 then icon = icons.volume._10 end

    volume_icon:set({ icon = { string = icon } })
    volume_percent:set({ label = { string = volume .. "%" } })
    volume_slider:set({ slider = { percentage = volume } })
    
    -- If volume changes via keyboard/system, keep popup alive
    if volume_bracket:query().popup.drawing == "on" then reset_timer() end
end)

local function volume_scroll(env)
    reset_timer()
    local delta = env.INFO.delta
    if env.INFO.modifier == "ctrl" then delta = delta / 10 end
    sbar.exec('osascript -e "set volume output volume (output volume of (get volume settings) + ' .. delta .. ')"')
end

volume_icon:subscribe("mouse.scrolled", volume_scroll)
volume_percent:subscribe("mouse.scrolled", volume_scroll)
volume_slider:subscribe("mouse.clicked", reset_timer)

-- Toggling
volume_icon:subscribe("mouse.clicked", function()
    local drawing = volume_bracket:query().popup.drawing
    if drawing == "off" then
        volume_bracket:set({ popup = { drawing = true } })
        reset_timer()
    else
        close_popup()
    end
end)

-- Background timer (checking every second)
local timer_item = sbar.add("item", { drawing = false, update_freq = 1 })
timer_item:subscribe("routine", function()
    if timer > 0 then
        timer = timer - 1
        if timer == 0 then close_popup() end
    end
end)
