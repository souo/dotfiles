local sbar = require("sketchybar")
local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Launch helper
sbar.exec("killall media_helper >/dev/null 2>&1; $CONFIG_DIR/helpers/event_providers/media_helper/bin/media_helper custom_media_change &")

local media_time = sbar.add("item", "widgets.media.time", {
    position = "center",
    update_freq = 1,
    icon = { font = "sketchybar-app-font:Regular:13.0", padding_right = 5, color = colors.white },
    label = { font = { family = settings.font.numbers, size = settings.font.size }, color = colors.white },
})

local media_title = sbar.add("item", "widgets.media.title", {
    position = "center",
    icon = { drawing = false },
    label = { max_chars = 15, scroll_duration = 100, font = { family = settings.font.zh_cn, size = settings.font.size }, color = colors.accent },
})

local m_state = { playing = false, title = "", app = "", pos = 0, dur = 0 }

local function format_time(seconds)
    local s = tonumber(seconds) or 0
    if s <= 0 then return "0:00" end
    return string.format("%d:%02d", math.floor(s / 60), math.floor(s % 60))
end

local function update_media_ui()
    local active = m_state.title ~= "" and m_state.title ~= "null"
    media_time:set({ drawing = active })
    media_title:set({ drawing = active })
    if not active then return end

    local icon = app_icons[m_state.app] or ":music:"
    local time_str = format_time(m_state.pos) .. " / " .. format_time(m_state.dur)

    media_time:set({
        icon = { string = icon, color = m_state.playing and colors.accent or colors.white },
        label = { string = time_str }
    })
    media_title:set({ label = { string = m_state.title } })
end

local function fetch_media()
    local cmd = [[ /opt/homebrew/bin/media-control get --now 2>/dev/null | /opt/homebrew/bin/jq -r 'if . == null or . == {} then "STOPPED" else "\(.playing)|\(.elapsedTimeNow // 0)|\(.duration // 0)|\(.title) · \(.artist)|\(."app-name" // .bundleIdentifier // "Music")" end' ]]
    sbar.exec(cmd, function(res)
        if not res or res == "" or res == "STOPPED" then m_state.title = ""
        else
            local playing, pos, dur, title, app = res:match("^(.-)|(.-)|(.-)|(.-)|(.-)%s*$")
            if playing then
                m_state.playing = (playing == "true")
                m_state.pos = math.floor(tonumber(pos) or 0)
                m_state.dur = math.floor(tonumber(dur) or 0)
                m_state.title = title; m_state.app = app
            end
        end
        update_media_ui()
    end)
end

-- Controls
local function toggle_play() sbar.exec("media-control toggle-play-pause", fetch_media) end
local function next_track() sbar.exec("media-control next-track", fetch_media) end
local function prev_track() sbar.exec("media-control previous-track", fetch_media) end

-- Events
media_time:subscribe({"custom_media_change", "media_change", "front_app_switched", "forced"}, fetch_media)
media_time:subscribe("routine", function()
    if m_state.playing then
        m_state.pos = m_state.pos + 1; update_media_ui()
        if m_state.pos % 15 == 0 then fetch_media() end
    elseif m_state.title == "" then fetch_media() end
end)

-- Interaction
media_time:subscribe("mouse.clicked", toggle_play)
media_title:subscribe("mouse.clicked", toggle_play)

-- Scroll to change tracks
media_title:subscribe("mouse.scrolled", function(env)
    if env.INFO.delta > 0 then next_track() else prev_track() end
end)
media_time:subscribe("mouse.scrolled", function(env)
    if env.INFO.delta > 0 then next_track() else prev_track() end
end)

fetch_media()
