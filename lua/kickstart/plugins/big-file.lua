return {
  'ouuan/nvim-bigfile',
  lazy = false,
  priority = 1000,
  opts = {
    size_limit = 5 * 1024 * 1024,
    ft_size_limits = {},
    notification = true,
    syntax = true,
    hook = function(buf, _)
      vim.b[buf].large_file = true
      vim.b[buf].completion = false
      pcall(function()
        vim.treesitter.stop(buf)
      end)
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end
        local clients = vim.lsp.get_clients and vim.lsp.get_clients { bufnr = buf } or vim.lsp.get_active_clients { bufnr = buf }
        for _, client in ipairs(clients) do
          vim.lsp.buf_detach_client(buf, client.id)
        end
      end)
    end,
  },
}
