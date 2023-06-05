---@type MappingsTable
local M = {}

M.custom = {
  n = {
    ["<leader>q"] = { "<cmd> wqa <CR>", "Save & Quit", opts = { nowait = true } },
    ["<leader>w"] = { "<cmd> wa <CR>", "Save & Quit", opts = { nowait = true } },

    ["<C-p>"] = { "<cmd> Telescope find_files <CR>", "Find files" },
    ["<leader>h"] = { "<cmd> Telescope help_tags <CR>", "Find files" },

    -- Move text with alt-j/k
    ["<A-j>"] = { "<cmd> m .+1 <CR>==" },
    ["<A-k>"] = { "<cmd> m .-2 <CR>==" },
    [";"] = { ":", "enter command mode", opts = { nowait = true } },

    ["<S-j>"] = {
      function()
        vim.diagnostic.goto_next { float = { border = "rounded" } }
      end,
      "Goto next",
    },
    ["gl"] = {
      function()
        vim.diagnostic.open_float { border = "rounded" }
      end,
      "Floating diagnostic",
    },
  },

  v = {

    -- Move text with alt-j/k
    ["<A-k>"] = { ":m '<-2<CR>gv-gv", "Move selection up" },
    ["<A-j>"] = { ":m '>+1<CR>gv-gv", "Move selection down" },

    -- Dont stop visual mode on indent
    ["<"] = { "<gv" },
    [">"] = { ">gv" },
  },
}

M.disabled = {
  n = {
    -- Unmap to unblock save
    ["<leader>wa"] = "",
    ["<leader>wl"] = "",
    ["<leader>wr"] = "",
    ["<leader>wk"] = "",
    ["<leader>wK"] = "",
  },
}

return M
