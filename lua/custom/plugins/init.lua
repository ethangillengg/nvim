-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    event = 'BufReadPost',
    init = function()
      vim.api.nvim_create_autocmd('BufReadPre', { command = 'GitConflictRefresh' })
    end,
    opts = {
      list_opener = 'Telescope quickfix',
      default_mappings = {
        ours = 'co',
        theirs = 'ct',
        none = 'c0',
        both = 'cb',
        next = 'cn',
        prev = 'cN',
      },
      highlights = {
        incoming = 'DiffAdd',
        current = 'DiffChange',
      },
    },
    cmd = {
      'GitConflictChooseBase',
      'GitConflictChooseTheirs',
      'GitConflictChooseOurs',
      'GitConflictChooseBoth',
      'GitConflictChooseNone',
      'GitConflictIncoming',
      'GitConflictIncomingLabel',
      'GitConflictListQf',
      'GitConflictNextConflict',
      'GitConflictPrevConflict',
      'GitConflictRefresh',
    },

    config = true,
    keys = {
      { '<leader>gq', '<cmd>GitConflictListQf<CR>', desc = 'Git: Conflicts' },
    },
  },
}
