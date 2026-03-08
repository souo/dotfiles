local sbar = require("sketchybar")
local colors = require("colors")
local settings = require("settings")

local COLOR_ICON_PLAYING = colors.yellow
local COLOR_ICON_PAUSED  = colors.yellow
local COLOR_TIME_TEXT    = colors.grey
local COLOR_TITLE_TEXT   = colors.blue_bright

local helper_cmd = "killall media_helper >/dev/null 2>&1; ~/.dotfiles/config/sketchybar/helpers/event_providers/media_helper/bin/media_helper custom_media_change &"
sbar.exec(helper_cmd)

-- ==========================================
-- 1. 定义 Widgets
-- ==========================================
local media_time = sbar.add("item", "widgets.media.time", {
    position = "center",
    update_freq = 1, -- ⚠️ 永远保持 1，绝不动态修改，防止定时器假死
    icon = {
        string = "▶",
        padding_right = 5,
        color = COLOR_ICON_PAUSED,
        font = {
            family = settings.font_icon.text,
            style = settings.font.style_map["Regular"],
            size = settings.font.size,
        }
    },
    label = {
        string = "0:00 - 0:00",
        padding_right = 8,
        color = COLOR_TIME_TEXT,
        font = {
            family = settings.font.numbers,
            style = settings.font.style_map["Regular"],
            size = settings.font.size,
        }
    },
})

local media_title = sbar.add("item", "widgets.media.title", {
    position = "center",
    icon = { drawing = false },
    label = {
        string = "Loading...",
        max_chars = 15,
        scroll_duration = 100,
        color = COLOR_TITLE_TEXT,
        font = {
            family = settings.font.zh_cn,
            style = settings.font.style_map["Regular"],
            size = settings.font.size,
        }
    },
})

-- ==========================================
-- 2. 状态缓存
-- ==========================================
local m_state = {
    playing = false,
    position = 0,
    duration = 0,
    title = "",
    artist = ""
}

local function format_time(seconds)
    local s = tonumber(seconds) or 0
    if s <= 0 then return "0:00" end
    local mins = math.floor(s / 60)
    local secs = math.floor(s % 60)
    return string.format("%d:%02d", mins, secs)
end

-- ==========================================
-- 3. 渲染 UI (纯本地状态驱动)
-- ==========================================
local function render_ui()
    if not m_state.title or m_state.title == "" then
        media_time:set({ drawing = false })
        media_title:set({ drawing = false })
        return
    end

    local icon_str = m_state.playing and "⏸" or "▶"
    local icon_col = m_state.playing and COLOR_ICON_PLAYING or COLOR_ICON_PAUSED
    
    local time_str = format_time(m_state.position) .. " - " .. format_time(m_state.duration)
    
    local text = m_state.title
    if m_state.artist and m_state.artist ~= "" and m_state.artist ~= "null" then
        text = text .. " - " .. m_state.artist
    end

    media_time:set({
        drawing = true,
        icon = { string = icon_str, color = icon_col },
        label = { string = time_str }
    })

    media_title:set({
        drawing = true,
        label = { string = text }
    })
end

-- ==========================================
-- 4. 核心逻辑：带防抖(Debounce)的数据拉取
-- ==========================================
local fetch_counter = 0 -- 防抖计数器
local sync_counter = 0  -- 校准计数器

local function fetch_media_info()
    fetch_counter = fetch_counter + 1
    local current_fetch = fetch_counter

    -- 延迟 0.15 秒，等待系统状态彻底变更完毕后再拉取，完美避免拉到旧数据！
    sbar.exec("sleep 0.15", function()
        -- 如果在等待期间又有新的触发，就放弃这次旧的请求 (防抖核心)
        if current_fetch ~= fetch_counter then return end

        local cmd = [[
            OUTPUT=$(/opt/homebrew/bin/media-control get 2>/dev/null)
            if [ -z "$OUTPUT" ] || [ "$OUTPUT" == "null" ] || [ "$OUTPUT" == "{}" ]; then
                echo "STOPPED"
            else
                echo "$OUTPUT" | /opt/homebrew/bin/jq -r '[(.playing? // .isPlaying? // false), (.elapsedTime? // .currentTime? // .position? // 0), (.duration? // 0), (.title? // ""), (.artist? // "")] | join("|")'
            fi
        ]]

        sbar.exec(cmd, function(result)
            -- 命令执行完后再次确认没有新的请求覆盖
            if current_fetch ~= fetch_counter then return end

            result = result:gsub("^%s*(.-)%s*$", "%1")

            if result == "STOPPED" or result == "" then
                m_state.playing = false
                m_state.title = ""
                render_ui()
                return
            end

            local playing_str, position, duration, title, artist = result:match("^(.-)|(.-)|(.-)|(.-)|(.*)$")

            local new_playing = (playing_str == "true")
            local new_position = math.floor(tonumber(position) or 0)
            local new_duration = math.floor(tonumber(duration) or 0)

            -- 修复暂停时进度归零 Bug
            if not new_playing and new_position == 0 and m_state.title == title then
                new_position = m_state.position
            end

            m_state.playing = new_playing
            m_state.position = new_position
            m_state.duration = new_duration
            m_state.title = title
            m_state.artist = artist

            render_ui()
        end)
    end)
end

-- 永远以 1Hz 运行，但只有在真正 playing 时才让时间前进
media_time:subscribe("routine", function()
    if m_state.playing and m_state.duration > 0 then
        -- 1. 本地预测递增
        m_state.position = m_state.position + 1
        if m_state.position > m_state.duration then
            m_state.position = m_state.duration
        end
        render_ui()

        -- 2. 每隔 15 秒强制校准一次进度，防止漂移或手动拖动进度条
        sync_counter = sync_counter + 1
        if sync_counter >= 15 then
            sync_counter = 0
            fetch_media_info()
        end
    end
end)

media_time:subscribe("custom_media_change", fetch_media_info)
media_time:subscribe("forced", fetch_media_info)

-- ==========================================
-- 5. 交互控制
-- ==========================================
local function toggle_play()
    sbar.exec("/opt/homebrew/bin/media-control toggle-play-pause && sketchybar --trigger custom_media_change")
end

local function change_track(env)
    local action = env.INFO.delta > 0 and "next-track" or "previous-track"
    sbar.exec("/opt/homebrew/bin/media-control " .. action .. " && sketchybar --trigger custom_media_change")
end

media_time:subscribe("mouse.clicked", toggle_play)
media_title:subscribe("mouse.clicked", toggle_play)

media_time:subscribe("mouse.scrolled", change_track)
media_title:subscribe("mouse.scrolled", change_track)

-- 初始化拉取
fetch_media_info()