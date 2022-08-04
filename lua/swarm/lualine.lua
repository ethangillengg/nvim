local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end

-- local custom_palenight = require'lualine.themes.palenight'
-- local reddish = '#ff5988'
-- local purplish = '#e4a6f5'
-- custom_palenight.normal.a.bg = reddish
-- custom_palenight.normal.b.fg = reddish
-- custom_palenight.visual.a.bg = purplish
-- custom_palenight.visual.b.fg = purplish

local transparent_palenight = require'lualine.themes.palenight'
transparent_palenight.normal.c.bg = nil
transparent_palenight.inactive.c.bg = nil



lualine.setup{
  options = {
    theme = transparent_palenight,
    section_separators = '',
    component_separators = ''
  }
}
