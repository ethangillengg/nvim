return {
  { "nvim-lua/popup.nvim" }, --other api for stuffs
  { "nvim-lua/plenary.nvim" }, --api for stuffs
  { "kyazdani42/nvim-web-devicons" }, --icons for stuffs

  { "windwp/nvim-autopairs",       event = "BufEnter", config = true }, --bracket pairs
  { "windwp/nvim-ts-autotag",      event = "BufEnter", config = true }, -- other auto pairs (html for example)

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {

      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      },
    },
    lazy = false,
    keys = {
      { "<c-p>",     "<cmd>Telescope fd<cr>",          desc = "Find File" },
      { "<leader>r", "<cmd>Telescope live_grep<cr>",   desc = "Grep Word" },
      { "<leader>c", "<cmd>Telescope colorscheme<cr>", desc = "Theme" },
      { "<leader>h", "<cmd>Telescope help_tags<cr>",   desc = "Help" },
      { "<leader>t", "<cmd>Telescope builtin<cr>",     desc = "Telescope Builtins" },
    },
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = "❯ ",
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
        },
        file_ignore_patterns = {
          "^wwwroot\\",
        },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("fzf")
    end,
  }, --telescope
  --[[ { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- fast sorter for telescope ]]

  {
    "numToStr/Comment.nvim",
    event = "BufEnter",
    --configure later?
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    config = true,
  }, -- Easily comment stuff

  -- git integration
  {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter",
    keys = {
      { "<leader>g", "<cmd>Gitsigns diffthis<cr>", desc = "Git Diff" },
      {
        "<c-g>",
        function()
          local gitsigns = require("gitsigns")
          gitsigns.next_hunk()
          vim.schedule(function()
            gitsigns.preview_hunk_inline()
          end)
        end,
        desc = "Preview next hunk",
      },
    },
    opts = {
      signs = {
        add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        change = {
          hl = "GitSignsChange",
          text = "▎",
          numhl = "GitSignsChangeNr",
          linehl = "GitSignsChangeLn",
        },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = {
          hl = "GitSignsChange",
          text = "▎",
          numhl = "GitSignsChangeNr",
          linehl = "GitSignsChangeLn",
        },
        untracked = { text = "▎" },
        --[[ untracked = { text = "┆" }, ]]
      },
      current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        delay = 0,
        virt_text_priority = 0,
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
      },
    },
  },

  -- keymaps
  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 10
      require("which-key").setup({

        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  },

  -- UI
  { "stevearc/dressing.nvim" }, -- styling for lsp rename and code actions

  -- Lets you use git and file managers
  {
    "is0n/fm-nvim",
    keys = {
      -- Lf + lazygit mappings (fm-nvim)
      { "<leader>d", "<cmd>Gitui<cr>", desc = "Gitui" },
      {
        "<leader>e",
        function()
          -- command to start lf at the current file
          require("fm-nvim").Lf(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
        end,
        desc = "Lf",
      },
    },
    opts = {
      mappings = {
        ESC = "q",
      },
      ui = {
        float = {
          -- border = "rounded",
          height = 1,
          width = 0.9,
        },
      },
    },
  },
}
