local status_ok, _ = pcall(require, "lspconfig")
if(not status_ok) then
  return
end

require("swarm.lsp.lsp-installer")
require("swarm.lsp.handlers").setup()
require("swarm.lsp.null-ls")
