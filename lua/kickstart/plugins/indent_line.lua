return {
  { -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {
      -- Start disabled by default
      enabled = false,
    },
    keys = {
      { '<leader>ti', '<cmd>IBLToggle<cr>', desc = '[T]oggle [I]ndentation guides' },
      { '<leader>te', '<cmd>IBLEnable<cr>', desc = '[T]oggle [E]nable indentation guides' },
      { '<leader>td', '<cmd>IBLDisable<cr>', desc = '[T]oggle [D]isable indentation guides' },
    },
  },
}
