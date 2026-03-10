# Sketchybar

## Context

Analyze following sources, incl. links and then the local sketchybar files.

- <https://felixkratz.github.io/SketchyBar/config/bar>
- <https://github.com/FelixKratz/SketchyBar>
- <https://github.com/FelixKratz/SbarLua>
- <https://github.com/FelixKratz/SketchyBarHelper>
- <https://github.com/acsandmann/AeroSpaceLua>
- <https://github.com/FelixKratz/SketchyBar/discussions/47>
- <https://github.com/FelixKratz/SketchyBar/discussions/12>

Sketchybar interacts with aerospace:

- <https://github.com/nikitabobko/AeroSpace>
- <https://nikitabobko.github.io/AeroSpace/guide>

Analyze the current aerospace config and how it interacts at: ~/.config/aerospace/aerospace.toml

Sketchybar is registered as a brew service.
The logs can be found at: /opt/homebrew/var/log/sketchybar/sketchybar*

## Custom Icons (sketchybar-app-font)

This setup supports adding custom SVG icons to `sketchybar-app-font` automatically.

1. **Add SVG**: Place your `.svg` icon in `config/sketchybar/assets/svgs/MyCustomApp.svg`.
2. **Add Mapping**: Create an extensionless file in `config/sketchybar/assets/mappings/MyCustomApp` with the actual system application name (e.g., `My Custom App`) as its content.
3. **Build**: Run `./config/sketchybar/setup.sh`.

The script will:

- Inject your assets into the `sketchybar-app-font` source.
- Rebuild the font (`.ttf`) and Lua icon map (`icon_map.lua`).
- Update your local `config/sketchybar/helpers/icon_map.lua` automatically.
