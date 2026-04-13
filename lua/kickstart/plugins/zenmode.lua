return {
  'folke/zen-mode.nvim',
  cmd = 'ZenMode',
  opts = {
    window = {
      backdrop = 0.95,
      width = 120,
      height = 1,
    },
    plugins = {
      options = {
        enabled = true,
        statusline = 0,
      },
    },
  },
  keys = {
    { '<leader>z', '<cmd>ZenMode<cr>', desc = 'Toggle Zen Mode' },
  },
}
