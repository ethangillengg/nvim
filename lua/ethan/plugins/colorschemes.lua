return {
    -- colors!!
    { "catppuccin/nvim",         name = "catppuccin" },
    { "kyazdani42/blue-moon" }, --cool colorscheme
    { "sainnhe/sonokai" },
    { "folke/tokyonight.nvim" },
    { "ellisonleao/gruvbox.nvim" },

    --allow transparency for colorschemes that don't support it
    {
        "xiyaowong/nvim-transparent",
        enable = true,
        opts = {
            extra_groups = { -- table/string: additional groups that should be cleared
                -- In particular, when you set it to 'all', that means all available groups
                "all",
                "NormalFloat",
                "FloatBorder",
                -- example of akinsho/nvim-bufferline.lua
                -- "BufferLineTabClose",
                -- "BufferlineBufferSelected",
                -- "BufferLineFill",
                -- "BufferLineBackground",
                -- "BufferLineSeparator",
                -- "BufferLineIndicatorSelected",
            },
            exclude_groups = {}, -- table: groups you don't want to clear
        },
    },
}
