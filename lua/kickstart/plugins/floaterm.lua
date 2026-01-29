return {
  'nvzone/floaterm',
  dependencies = 'nvzone/volt',
  opts = {},
  cmd = 'FloatermToggle',
  keys = {
    { '<leader>tt', '<cmd>FloatermToggle<cr>', desc = '[T]oggle [T]erminal', mode = 'n' },
    { '<leader>tt', '<C-\\><C-n><cmd>FloatermToggle<cr>', desc = '[T]oggle [T]erminal', mode = 't' },
  },
}
