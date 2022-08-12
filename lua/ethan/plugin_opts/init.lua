local load_opts = function(filename)
  require('ethan.plugin_opts.' .. filename)
end

load_opts('telescope')
load_opts('autopairs')
load_opts('comment')
load_opts('lualine')
load_opts('transparent')
load_opts('toggleterm')
load_opts('alpha')
load_opts('impatient')
load_opts('neotree')
load_opts('cmp')
