local load_lua = function(filename)
  return require('ethan.lsp.' .. filename)
end

load_lua('handlers').setup()
load_lua('mason')
load_lua('null_ls')
