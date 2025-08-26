local wezterm = require('wezterm')
local gpu_adapters = require('utils.gpu_adapter')
local colors = require('colors.vitness_dark')

return {
   animation_fps = 60,
   max_fps = 60,
   front_end = 'WebGpu',
   webgpu_power_preference = 'HighPerformance',
   webgpu_preferred_adapter = gpu_adapters:pick_best(),

   -- color scheme
   colors = colors,

   -- background
   background = {
      {
         source = { File = wezterm.GLOBAL.background },
         horizontal_align = 'Center',
      },
      {
         source = { Color = colors.background },
         height = '120%',
         width = '120%',
         vertical_offset = '-10%',
         horizontal_offset = '-10%',
         opacity = 0.96,
      },
   },

   -- scrollbar
   enable_scroll_bar = true,

   -- tab bar
   enable_tab_bar = true,
   hide_tab_bar_if_only_one_tab = true,
   tab_max_width = 25,
   show_tab_index_in_tab_bar = false,
   show_tabs_in_tab_bar = true,
   switch_to_last_active_tab_when_closing_tab = true,
   tab_and_split_indices_are_zero_based = false,
   use_fancy_tab_bar = false,

   -- window
   window_padding = {
      left = 0,
      right = 0,
      top = 15,
      bottom = 7.5,
   },
   window_close_confirmation = 'NeverPrompt',
   window_frame = {
      active_titlebar_bg = '#121212',

   },
   -- inactive_pane_hsb = {
   --    saturation = 0.9,
   --    brightness = 0.65,
   -- },
   inactive_pane_hsb = {
      saturation = 1,
      brightness = 1,
   },
}
