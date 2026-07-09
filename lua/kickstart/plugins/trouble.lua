return {
  'folke/trouble.nvim',
  opts = {},
  cmd = 'Trouble',
  keys = {
    {
      '<leader>xx',
      function()
        require('trouble').toggle('diagnostics')
      end,
      desc = 'Trouble diagnostics',
    },
    {
      '[t',
      function()
        require('trouble').next { skip_groups = true, jump = true }
      end,
      desc = 'Next Trouble item',
    },
    {
      ']t',
      function()
        require('trouble').previous { skip_groups = true, jump = true }
      end,
      desc = 'Prev Trouble item',
    },
  },
}
