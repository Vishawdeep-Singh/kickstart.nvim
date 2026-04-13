return {
  'supermaven-inc/supermaven-nvim',
  event = 'InsertEnter',
  config = function()
    require('supermaven-nvim').setup {
      keymaps = {
        accept_suggestion = '<C-y>',
        clear_suggestion = '<C-]>',
        accept_word = '<M-w>',
      },
      condition = function()
        return vim.b.large_file == true
      end,
    }
  end,
}
