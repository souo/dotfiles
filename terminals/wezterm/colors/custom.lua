local colorscheme = {
    foreground = 'rgba(219, 215, 202, 0.93)',
    background = '#121212',
    cursor_bg = "#f5e0dc",
    cursor_border = "#f5e0dc",
    cursor_fg = "#11111b",
    selection_bg = 'rgba(238, 238, 238, 0.09)',
    selection_fg = 'rgba(219, 215, 202, 0.93)',
    ansi = {
       '#393a34', -- black
       '#cb7676', -- red
       '#4d9375', -- green
       '#e6cc77', -- yellow
       '#6394bf', -- blue
       '#d9739f', -- magenta/purple
       '#5eaab5', -- cyan
       '#dbd7ca', -- white
    },
    brights = {
       '#777777', -- black
       '#cb7676', -- red
       '#4d9375', -- green
       '#e6cc77', -- yellow
       '#6394bf', -- blue
       '#d9739f', -- magenta/purple
       '#5eaab5', -- cyan
       '#ffffff', -- white
    },
    tab_bar = {
       background = 'rgba(0, 0, 0, 0.4)',
       active_tab = {
          bg_color = '#121212',
          fg_color = 'rgba(219, 215, 202, 0.93)',
       },
       inactive_tab = {
          bg_color = '#121212',
          fg_color = '#959da5',
       },
       inactive_tab_hover = {
          bg_color = '#181818',
          fg_color = 'rgba(219, 215, 202, 0.93)',
       },
       new_tab = {
          bg_color = "#121212",
          fg_color = 'rgba(219, 215, 202, 0.93)',
       },
       new_tab_hover = {
          bg_color = '#181818',
          fg_color = 'rgba(219, 215, 202, 0.93)',
          italic = true,
       },
    },
    visual_bell = '#121212',
    indexed = {
       [16] = "#fab387",
       [17] = "#f5e0dc",
    },
    scrollbar_thumb = '#121212',
    split = '#191919',
    compose_cursor = "#f2cdcd",
 }

 return colorscheme
