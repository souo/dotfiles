local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

local popup_width = 180 

-- Volume percentage display
local volume_percent = sbar.add("item", "widgets.volume1", {
    position = "right",
    icon = { drawing = false },
    label = {
        string = "??%",
        padding_left = -1,
        padding_right = settings.padding.icon_label_item.label.padding_right,
        font = {
            family = settings.font.numbers,
            style = settings.font.style_map["Bold"],
            size = settings.label_size,
        },
        align = "right",
    },
    background = { drawing = false },
})

-- Volume icon display
local volume_icon = sbar.add("item", "widgets.volume2", {
    position = "right",
    icon = {
        color = colors.white,
        font = {
            family = settings.font_icon.text,
            style = settings.font_icon.style_map["Bold"],
            size = settings.icon_size
        },
        padding_left = settings.padding.icon_label_item.icon.padding_left - 4,
        padding_right = settings.padding.icon_item.icon.padding_right - 10,
        string = icons.volume._100,
    },
    background = { drawing = false },
    label = { drawing = false },
})

-- Bracket for both items
local volume_bracket = sbar.add("bracket", "widgets.volume.bracket", {
    volume_icon.name,
    volume_percent.name
}, {
    background = { color = colors.bg1 },
    popup = { align = "center" },
})

-----------------------------------------------------
-- POPUP ITEMS (按从上到下的顺序添加)
-----------------------------------------------------

-- 1. 输出设备标签
local volume_device_output = sbar.add("item", "volume.device.output", {
    position = "popup." .. volume_bracket.name,
    width = popup_width,
    align = "left",
    icon = { drawing = false },
    label = { 
        string = "Output: Loading...", 
        padding_left = 15,
        padding_right = 15,
        font = {
          family = settings.font.zh_cn,
          style = settings.font.style_map["Regular"],
          size = 14,
        }
    },
})

-- 2. 输入设备标签
local volume_device_input = sbar.add("item", "volume.device.input", {
    position = "popup." .. volume_bracket.name,
    width = popup_width,
    align = "left",
    icon = { drawing = false },
    label = { 
        string = "Input: Loading...", 
        padding_left = 15, 
        padding_right = 15,
        font = {
          family = settings.font.zh_cn,
          style = settings.font.style_map["Regular"],
          size = 14,
        }
    },
})

-- 3. Volume slider popup
local volume_slider = sbar.add("slider", popup_width, {
    position = "popup." .. volume_bracket.name,
    slider = {
        highlight_color = colors.accent,
        background = {
            color = colors.bg2,
            height = 6,
        },
        knob = {
            string = "",
            drawing = true,
            font = { 
              family = settings.font.text, 
              style = settings.font.style_map["Regular"],
              size = 14.0 
            },
        },
    },
    background = {
        color = colors.bg1,
        height = 30, -- 增加高度作为上下间距
        padding_left = 15,
        padding_right = 15,
    },
    click_script = 'osascript -e "set volume output volume $PERCENTAGE"'
})

-- 4. 声音设置按钮
local volume_settings = sbar.add("item", "volume.settings", {
    position = "popup." .. volume_bracket.name,
    width = popup_width,
    align = "left",
    icon = { 
        string = " ", -- 使用 Nerd Font 的齿轮图标 (如果显示乱码可以换成 SF Symbol 􀍟)
        padding_left = 15,
        font = {
          family = settings.font_icon.text,
          style = settings.font_icon.style_map["Bold"],
          size = 14,
        }
    },
    label = { 
        string = "声音设置",
        padding_left = 5,
        font = {
          family = settings.font.zh_cn,
          style = settings.font.style_map["Medium"],
          size = 14,
        }
    },
})

-----------------------------------------------------
-- LOGIC / ACTIONS
-----------------------------------------------------

-- Update volume display
volume_percent:subscribe("volume_change", function(env)
    local volume = tonumber(env.INFO)
    local icon = icons.volume._0
    if volume > 60 then
        icon = icons.volume._100
    elseif volume > 30 then
        icon = icons.volume._66
    elseif volume > 10 then
        icon = icons.volume._33
    elseif volume > 0 then
        icon = icons.volume._10
    end

    local lead = ""
    if volume < 10 then
        lead = "0"
    end

    volume_icon:set({ icon = { string = icon } })
    volume_percent:set({ label = { string = lead .. volume .. "%" } })
    volume_slider:set({ slider = { percentage = volume } })
end)

local function volume_collapse_details()
    local drawing = volume_bracket:query().popup.drawing == "on"
    if not drawing then return end
    volume_bracket:set({ popup = { drawing = false } })
end

local function volume_toggle_details(env)
    local should_draw = volume_bracket:query().popup.drawing == "off"
    if should_draw then
        volume_bracket:set({ popup = { drawing = true } })
        -- 获取并更新当前输出设备
        sbar.exec("SwitchAudioSource -t output -c -f human", function(result)
            -- 使用 gsub 去除字符串前后的空格和换行符
            local device = result:gsub("^%s*(.-)%s*$", "%1")
            
            -- 判断是否为空，或者包含错误提示
            if device == "" or device:find("Could not find") then
                device = "未找到输出设备"
            end
            
            volume_device_output:set({ label = { string = "输出: " .. device } })
        end)
        
        -- 获取并更新当前输入设备 (麦克风)
        sbar.exec("SwitchAudioSource -t input -c -f human", function(result)
            local device = result:gsub("^%s*(.-)%s*$", "%1")
            
            if device == "" or device:find("Could not find") then
                device = "未找到输入设备"
            end
            
            volume_device_input:set({ label = { string = "输入: " .. device } })
        end)
    else
        volume_collapse_details()
    end
end

local function volume_scroll(env)
    local delta = env.INFO.delta
    if not (env.INFO.modifier == "ctrl") then delta = delta * 10.0 end
    sbar.exec('osascript -e "set volume output volume (output volume of (get volume settings) + ' .. delta .. ')"')
end

-- 声音设置点击事件：打开系统设置，并折叠 popup
volume_settings:subscribe("mouse.clicked", function()
    sbar.exec("open /System/Library/PreferencePanes/Sound.prefpane")
    volume_collapse_details()
end)

volume_icon:subscribe("mouse.clicked", volume_toggle_details)
volume_icon:subscribe("mouse.scrolled", volume_scroll)
volume_percent:subscribe("mouse.clicked", volume_toggle_details)
volume_percent:subscribe("mouse.exited.global", volume_collapse_details)
volume_percent:subscribe("mouse.scrolled", volume_scroll)