local load_opts = function(filename)
  local status_ok, _ = pcall(require, 'plugin_opts/' ..filename)
  if not status_ok then
    return
  end
end


local profile = 'plugin_opts'
local filename = 'telescope_opts'
require('' .. profile .. '/' .. filename)
