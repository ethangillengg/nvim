# My nvim setup

To install run the following commands in `$XDG_CONFIG_HOME`

```shell
git clone https://github.com/ethangillengg/nvim
nvim --headless "+Lazy! sync" +qa
```

# TODO

## Plugins

### Must Have

- [x] [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git integration: signs, hunk actions, blame, etc.
- [x] [folke/which-key.nvim](https://github.com/folke/which-key.nvim) - Neovim plugin that shows a popup with possible keybindings of the command you started typing.
- [ ] [is0n/fm-nvim](https://github.com/is0n/fm-nvim) - Neovim plugin that lets you use your favorite terminal file managers (and fuzzy finders).
- [ ] [stevearc/dressing.nvim](https://github.com/stevearc/dressing.nvim) - Improve the built-in `vim.ui` interfaces with telescope, fzf, etc.
- [x] [RRethy/vim-illuminate](https://github.com/RRethy/vim-illuminate)
- [ ] [folke/neodev.nvim](https://github.com/folke/neodev.nvim)

### Test First

- [ ] [ms-jpq/coq_nvim](https://github.com/ms-jpq/coq_nvim) - Fast as F@%$ Neovim completion. SQLite, concurrent scheduler, hundreds of hours of optimization.
- [ ] [jubnzv/virtual-types.nvim](https://github.com/jubnzv/virtual-types.nvim) - Show type annotations as virtual text.
- [ ] [ray-x/navigator.lua](https://github.com/ray-x/navigator.lua) - Learn existing code quickly and navigate code like a breeze. A swiss army knife makes exploring LSP and 🌲Treesitter symbols a piece of 🍰.
- [ ] [weilbith/nvim-code-action-menu](https://github.com/weilbith/nvim-code-action-menu) - A floating pop-up menu for code actions to show code action information and a diff preview.
- [ ] [sindrets/diffview.nvim](https://github.com/sindrets/diffview.nvim) - Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
- [ ] [gorbit99/codewindow.nvim](https://github.com/gorbit99/codewindow.nvim) - Minimap plugin, that is closely integrated with treesitter and the builtin LSP to display more information to the user.
- [ ] [mrjones2014/legendary.nvim](https://github.com/mrjones2014/legendary.nvim) - Define your keymaps, commands, and autocommands as simple Lua tables, and create a legend for them at the same time (like VS Code's Command Palette), integrates with `which-key.nvim`.
- [ ] [rktjmp/lush.nvim](https://github.com/rktjmp/lush.nvim)
- [ ] [themercorp/themer.lua](https://github.com/themercorp/themer.lua)
- [ ] [ggandor/leap.nvim](https://github.com/ggandor/leap.nvim);

### Other

- [ ] Document my keymaps in [which-key](https://github.com/folke/which-key.nvim)
- [ ] Structure plugins like shown [here](https://github.com/folke/lazy.nvim#-structuring-your-plugins)
