local load_opts = function(filename)
  require('ethan.plugin_opts.' .. filename)
end

load_opts('telescope')
load_opts('autopairs')
