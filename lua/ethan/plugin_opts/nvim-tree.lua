-- examples for your init.lua

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
      --[[ adaptive_size = true, ]]
      centralize_selection = true,
      mappings = {
        list = {
          { key = "u", action = "dir_up" },
        },
      },
      float = {
        enable = true,
        quit_on_focus_loss = true,
        open_win_config = {
          relative = "editor",
          border = "rounded",
          width = 60,
          --[[ center window horizontally ]]
          col = (vim.fn.winwidth(0) - 60)/2,
          height = 35,
        --[[ put window at top 3rd of screen ]]
          row = (vim.fn.winheight(0)- 35)/3,
        },
      },
    },
    git = {
      ignore = false
    },
    filters = {
      dotfiles = false,
      custom = { "node_modules" },
    },
      actions = {
        open_file = {
          quit_on_open = true,
          resize_window = true,
          window_picker = {
            enable = false,
          },
        },
      },
  })

