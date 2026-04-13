return {
  'shortcuts/no-neck-pain.nvim',
  version = '*', -- stable version
  cmd = 'NoNeckPain',
  keys = {
    { '<leader>z', '<cmd>NoNeckPain<cr>', desc = 'Toggle Center Window' },
  },
  opts = {
    width = 120, -- or 180 for your 4K monitor
    buffers = {
      -- Don't change any colors or backgrounds
      scratchPad = {
        enabled = false,
      },
    },
    -- Keep all UI elements visible (default behavior)
  },
}
