local load_lua = function(filename)
  require('ethan.lsp.' .. filename)
end

load_lua('mason')
