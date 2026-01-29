return {
  'akinsho/bufferline.nvim',
  version = '*',
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers',
        themable = true,
        numbers = 'none',
        diagnostics = 'nvim_lsp',
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        separator_style = 'thin',
        always_show_bufferline = true,
      },
    }
    vim.keymap.set('n', '<S-h>', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
    vim.keymap.set('n', '<S-l>', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
  end,
}
