local status_ok, telescope = pcall(require, 'telescope')
if not status_ok then
  return
end

telescope.setup {
  defaults = {
    prompt_prefix = "   ",
    selection_caret = "❯ ",
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = 'top',
    },
  },
}

--load fzf into telescope
--[[ status_ok, fzf = pcall(require, 'telescope._extensions.fzf') ]]
--[[ if not status_ok then ]]
--[[   return ]]
--[[ end ]]
--[[ telescope.load_extension('fzf') ]]
