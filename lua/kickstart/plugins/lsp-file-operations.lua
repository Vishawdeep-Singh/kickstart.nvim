return {
  'antosha417/nvim-lsp-file-operations',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('lsp-file-operations').setup {
      -- Enable debug mode for troubleshooting
      debug = false,
      -- Timeout for LSP requests (in milliseconds)
      timeout_ms = 10000,
    }
  end,
}
