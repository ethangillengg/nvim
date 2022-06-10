return require('packer').startup(function() 
    use 'wbthomason/packer.nvim'

    -- Basic UI Pluins
    use 'windwp/nvim-autopairs'
    use 'tjdevries/colorbuddy.nvim'
    use 'bkegley/gloombuddy'
    use 'nvim-treesitter/nvim-treesitter'
    use {
      'nvim-telescope/telescope.nvim',
      requires = { {'nvim-lua/plenary.nvim'} }
    }
    use {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v2.x',
        requires = { 
          'nvim-lua/plenary.nvim',
          'kyazdani42/nvim-web-devicons', 
          'MunifTanjim/nui.nvim',
        }
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    -- LSP
    use 'neovim/nvim-lspconfig'
    use 'jose-elias-alvarez/null-ls.nvim'
    use 'jose-elias-alvarez/nvim-lsp-ts-utils'

    -- Autocompletion
    use 'hrsh7th/nvim-cmp' 
    use 'hrsh7th/cmp-nvim-lsp' 
end)
