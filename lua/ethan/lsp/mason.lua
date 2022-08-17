local status_ok, mason = pcall(require, "mason")
if not status_ok then
  return
end

status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status_ok then
  return
end

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end


mason.setup()
mason_lspconfig.setup()


-- setup handlers for all servers
-- see :h mason-lspconfig.setup_handlers()
mason_lspconfig.setup_handlers({
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.

    function (server_name) -- default handler (optional)
    local opts = {
      on_attach = require("ethan.lsp.handlers").on_attach,
      capabilities = require("ethan.lsp.handlers").capabilities,
      handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
          border = 'rounded',
          winhighlight = 'Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None',
          zindex = 1001,
          col_offset = 0,
          side_padding = 1,
        }),

        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
          border = 'rounded',
          winhighlight = 'Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None',
          zindex = 1001,
          col_offset = 0,
          side_padding = 1,
        }),
      }
    }
    lspconfig[server_name].setup(opts)
    end,
})
