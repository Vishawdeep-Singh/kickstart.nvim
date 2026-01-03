return {
  'ThePrimeagen/99',
  config = function()
    local _99 = require '99'

    local cwd = vim.uv.cwd()
    local basename = vim.fs.basename(cwd)

    _99.setup {
      logger = {
        level = _99.DEBUG,
        path = '/tmp/' .. basename .. '.99.debug',
        print_on_error = true,
      },
      md_files = { 'AGENT.md' },
    }

    vim.keymap.set('n', '<leader>9f', function()
      _99.fill_in_function()
    end)

    vim.keymap.set('v', '<leader>9v', function()
      _99.visual()
    end)

    vim.keymap.set('v', '<leader>9s', function()
      _99.stop_all_requests()
    end)
  end,
}
