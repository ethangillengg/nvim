return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        event = "BufReadPre",
        dependencies = { "neovim/nvim-lspconfig" },
        keys = {
          { "<leader>m", "<cmd>Mason<cr>", desc = "Open Mason" },
        },
        config = function()
          local lspconfig = require("lspconfig")
          local mason_lspconfig = require("mason-lspconfig")
          mason_lspconfig.setup()

          -- setup handlers for all servers
          -- see :h mason-lspconfig.setup_handlers()
          mason_lspconfig.setup_handlers({
            -- The first entry (without a key) will be the default handler
            -- and will be called for each installed server that doesn't have
            -- a dedicated handler.

            function(server_name) -- default handler (optional)
              local opts = {
                on_attach = require("ethan.lsp.handlers").on_attach,
                capabilities = require("ethan.lsp.handlers").capabilities,
              }
              lspconfig[server_name].setup(opts)
            end,
            ["sumneko_lua"] = function()
              lspconfig.sumneko_lua.setup({
                settings = {
                  Lua = {
                    runtime = {
                      version = "LuaJIT",
                    },
                    diagnostics = {
                      globals = { "vim" },
                    },
                  },
                },
                --make sure to copy these for any custom server attach functions
                on_attach = require("ethan.lsp.handlers").on_attach,
                capabilities = require("ethan.lsp.handlers").capabilities,
              })
            end,
          })
        end,
      },
    },
    config = function(_, opts)
      -- require("ethan.lsp.handlers").setup()
      local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      }

      for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
      end

      local config = {
        virtual_text = true,
        -- show signs
        signs = {
          active = signs,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
        },
      }

      vim.diagnostic.config(config)
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
      })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
      })
      require("mason").setup(opts)
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      local nls = require("null-ls")

      local formatting = nls.builtins.formatting
      local diagnostics = nls.builtins.diagnostics

      return {
        deug = false,
        sources = {
          formatting.prettierd,
          formatting.stylua,
          diagnostics.eslint_d,
          diagnostics.alex,
        },
      }
    end,
  },
  { "folke/neodev.nvim", config = true }, -- LSP for neovim config!

  -- TODO: highlight color breaks with transparency plugin and makes it all black
  -- {
  --   "j-hui/fidget.nvim",
  --   opts = {
  --     text = {
  --       spinner = "pipe", -- animation shown when tasks are ongoing
  --       done = "D", -- character shown when all tasks are complete
  --       commenced = "Started", -- message shown when task starts
  --       completed = "Completed", -- message shown when task completes
  --     },
  --   },
  --   window = {
  --     relative = "win", -- where to anchor, either "win" or "editor"
  --     blend = 100, -- &winblend for the window
  --     zindex = nil, -- the zindex value for the window
  --     border = "none", -- style of border for the fidget window
  --   },
  -- }, -- progress for loading lsp
}
