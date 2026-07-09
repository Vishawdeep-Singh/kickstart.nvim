return {
  'nvim-treesitter/nvim-treesitter-context',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('treesitter-context').setup {
      max_lines = 3,
      min_window_height = 0,
    }

    vim.keymap.set('n', '<leader>tc', '<cmd>TSContextToggle<CR>', { desc = '[T]oggle sticky [C]ontext' })
    vim.keymap.set('n', '<leader>tj', '<cmd>TSContext<CR>', { desc = '[T]reesitter context [J]ump' })
  end,
}
