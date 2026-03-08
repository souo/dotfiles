local sbar = require("sketchybar")
local colors = require("colors")
local settings = require("settings")

-- ==========================================
-- 1. 配置与样式
-- ==========================================
local COLOR_ICON_PLAYING = colors.yellow
local COLOR_ICON_PAUSED  = colors.grey
local COLOR_TIME_TEXT    = colors.grey
local COLOR_TITLE_TEXT   = colors.blue_bright

local app_icons = require("helpers.app_icons")

-- 将 Bundle Identifier 映射到 app_icons.lua 中的 key
local BUNDLE_ID_MAP = {
    ["com.apple.Music"]    = "Music",
    ["com.spotify.client"] = "Spotify",
    ["com.apple.Safari"]   = "Safari",
    ["com.google.Chrome"]  = "Google Chrome",
}

-- 启动事件辅助器
local helper_cmd = "killall media_helper >/dev/null 2>&1; ~/.dotfiles/config/sketchybar/helpers/event_providers/media_helper/bin/media_helper custom_media_change &"
sbar.exec(helper_cmd)

-- ==========================================
-- 2. 定义 Widgets
-- ==========================================
local media_time = sbar.add("item", "widgets.media.time", {
    position = "center",
    update_freq = 1,
    icon = {
        padding_right = 5,
        font = "sketchybar-app-font:Regular:13.0",
    },

    label = {
        string = "0:00",
        color = COLOR_TIME_TEXT,
        font = { family = settings.font.numbers, size = settings.font.size },
    },
})

local media_title = sbar.add("item", "widgets.media.title", {
    position = "center",
    icon = { drawing = false },
    label = {
        max_chars = 15,
        scroll_duration = 100,
        color = COLOR_TITLE_TEXT,
        font = { family = settings.font.zh_cn, size = settings.font.size },
    },
})

-- ==========================================
-- 3. 状态管理
-- ==========================================
local m_state = {
    playing = false,
    position = 0,
    duration = 0,
    title = "",
    artist = "",
    app = ""
}

local function format_time(seconds)
    local s = tonumber(seconds) or 0
    if s <= 0 then return "0:00" end
    return string.format("%d:%02d", math.floor(s / 60), math.floor(s % 60))
end

local function render_ui()
    local is_active = m_state.title and m_state.title ~= ""

    -- 智能显示/隐藏
    media_time:set({ drawing = is_active })
    media_title:set({ drawing = is_active })

    if not is_active then return end

    -- 进度条显示 (0:00 / 3:45)
    local time_str = format_time(m_state.position) .. " / " .. format_time(m_state.duration)

    -- 获取图标 (优先从库中查找，找不到则回退到 :music:)
    local app_name = BUNDLE_ID_MAP[m_state.app] or "Music"
    local icon_str = app_icons[app_name] or ":music:"
    local icon_col = m_state.playing and COLOR_ICON_PLAYING or COLOR_ICON_PAUSED

    -- 拼接标题 (书名 - 歌手)
    local display_text = m_state.title
    if m_state.artist and m_state.artist ~= "" and m_state.artist ~= "null" then
        display_text = display_text .. " · " .. m_state.artist
    end

    media_time:set({
        icon = { string = icon_str, color = icon_col },
        label = { string = time_str }
    })

    media_title:set({
        label = { string = display_text }
    })
end

-- ==========================================
-- 4. 核心：数据获取
-- ==========================================
local fetch_counter = 0
local sync_counter = 0

local function fetch_media_info()
    fetch_counter = fetch_counter + 1
    local current_fetch = fetch_counter
    -- 轻微延迟，防止拉到状态切换瞬间的垃圾数据
    sbar.exec("sleep 0.1", function()
        if current_fetch ~= fetch_counter then return end

        local cmd = [[
            OUTPUT=$(/opt/homebrew/bin/media-control get 2>/dev/null)
            if [ -z "$OUTPUT" ] || [ "$OUTPUT" == "null" ] || [ "$OUTPUT" == "{}" ]; then
                echo "STOPPED"
            else
                echo "$OUTPUT" | /opt/homebrew/bin/jq -r '[(.playing // false), (.elapsedTime // 0), (.duration // 0), (.title // ""), (.artist // ""), (.bundleIdentifier // "")] | join("|")'
            fi
        ]]

        sbar.exec(cmd, function(result)
            if current_fetch ~= fetch_counter then return end
            result = result:gsub("^%s*(.-)%s*$", "%1")

            if result == "STOPPED" or result == "" then
                m_state.title = ""
                render_ui()
                return
            end

            local playing_str, pos, dur, title, artist, app = result:match("^(.-)|(.-)|(.-)|(.-)|(.-)|(.*)$")

            m_state.playing = (playing_str == "true")
            m_state.position = math.floor(tonumber(pos) or 0)
            m_state.duration = math.floor(tonumber(dur) or 0)
            m_state.title = title
            m_state.artist = artist
            m_state.app = app

            render_ui()
        end)
    end)
end

-- ==========================================
-- 5. 订阅与交互
-- ==========================================

-- 1Hz 更新：仅在播放时本地递增，减少 CPU 消耗
media_time:subscribe("routine", function()
    if m_state.playing and m_state.duration > 0 then
        m_state.position = m_state.position + 1
        if m_state.position > m_state.duration then m_state.position = m_state.duration end
        render_ui()

        -- 每 15 秒同步一次真实进度，纠正本地累加误差
        sync_counter = sync_counter + 1
        if sync_counter >= 15 then
            sync_counter = 0
            fetch_media_info()
        end
    elseif m_state.title == "" then
        -- 如果 UI 没出来，每 5 秒尝试唤起一次（针对某些边缘情况）
        sync_counter = sync_counter + 1
        if sync_counter >= 5 then
            sync_counter = 0
            fetch_media_info()
        end
    end
end)

-- 响应所有可能的媒体变更事件
local media_events = { "custom_media_change", "media_change", "front_app_switched", "forced" }
for _, event in ipairs(media_events) do
    media_time:subscribe(event, fetch_media_info)
end

-- 点击切换播放/暂停
local function toggle_play()
    sbar.exec("/opt/homebrew/bin/media-control toggle-play-pause && sketchybar --trigger custom_media_change")
end

-- 滚动切换曲目
local function change_track(env)
    local action = env.INFO.delta > 0 and "next-track" or "previous-track"
    sbar.exec("/opt/homebrew/bin/media-control " .. action .. " && sketchybar --trigger custom_media_change")
end

media_time:subscribe("mouse.clicked", toggle_play)
media_title:subscribe("mouse.clicked", toggle_play)
media_time:subscribe("mouse.scrolled", change_track)
media_title:subscribe("mouse.scrolled", change_track)

-- 初始化
fetch_media_info()
