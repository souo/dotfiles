local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local brew = sbar.add("item", "widgets.brew", {
    position = "right",
    update_freq = 3600,
    icon = {
        string = "󰏖",
        font = { family = settings.font_icon.text, style = "Bold", size = settings.icon_size },
        padding_left = settings.padding.icon_label_item.icon.padding_left,
        padding_right = settings.padding.icon_label_item.icon.padding_right,
    },
    label = {
        string = "?",
        font = { family = settings.font.numbers, style = "Bold", size = settings.label_size },
        padding_right = settings.padding.icon_label_item.label.padding_right,
    },
})

local cached_packages = {}

local function update_brew()
    -- EXTREME FIX: Use a subshell with a cleaned PATH and HOMEBREW variables to avoid the ruby 'success?' error
    -- Also use 'timeout' to prevent brew from hanging the event loop if it gets stuck
    local cmd = [[ /bin/zsh -c "export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_ANALYTICS=1 HOMEBREW_NO_ENV_HINTS=1; brew outdated -q 2>/dev/null | grep -vE '^(Error:|Please report|/opt/homebrew|Troubleshooting|undefined method|.*\.rb:)'" ]]

    sbar.exec(cmd, function(output)
        cached_packages = {}
        local count = 0
        
        if output and type(output) == "string" and output ~= "" then
            for line in output:gmatch("[^\r\n]+") do
                -- Final filter for the specific ruby error string
                if not line:find("success%?") and not line:find("nil") then
                    count = count + 1
                    table.insert(cached_packages, line)
                end
            end
        end

        local color = colors.green
        if count >= 10 then color = colors.red
        elseif count > 0 then color = colors.yellow
        end

        brew:set({
            label = { string = tostring(count), color = color },
            icon = { color = color }
        })
    end)
end

brew:subscribe({"routine", "forced", "system_woke"}, update_brew)

local brew_popup = sbar.add("item", {
    position = "popup." .. brew.name,
    label = { font = { family = settings.font.text, size = 10.0 }, padding_left = 10, padding_right = 10 },
    icon = { drawing = false },
})

brew:subscribe("mouse.clicked", function(env)
    local is_drawing = brew:query().popup.drawing == "on"
    if not is_drawing then
        local label_str = #cached_packages > 0 and table.concat(cached_packages, "\n") or "No updates available"
        brew_popup:set({ label = { string = label_str } })
        brew:set({ popup = { drawing = true } })
    else
        brew:set({ popup = { drawing = false } })
    end
end)

sbar.add("bracket", "widgets.brew.bracket", { brew.name }, { background = { color = colors.bg1 } })
sbar.add("item", { position = "right", width = settings.group_paddings })
