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
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match 'error' and ' ' or ' '
          return ' ' .. icon .. count
        end,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        separator_style = 'thin',
        always_show_bufferline = true,
      },
      highlights = {
        error = {
          fg = { attribute = 'fg', highlight = 'DiagnosticError' },
          bg = { attribute = 'bg', highlight = 'Normal' },
        },
        error_visible = {
          fg = { attribute = 'fg', highlight = 'DiagnosticError' },
          bg = { attribute = 'bg', highlight = 'Normal' },
        },
        error_selected = {
          fg = { attribute = 'fg', highlight = 'DiagnosticError' },
          bg = { attribute = 'bg', highlight = 'Normal' },
          bold = true,
          italic = false,
        },
        warning = {
          fg = { attribute = 'fg', highlight = 'DiagnosticWarn' },
          bg = { attribute = 'bg', highlight = 'Normal' },
        },
        warning_visible = {
          fg = { attribute = 'fg', highlight = 'DiagnosticWarn' },
          bg = { attribute = 'bg', highlight = 'Normal' },
        },
        warning_selected = {
          fg = { attribute = 'fg', highlight = 'DiagnosticWarn' },
          bg = { attribute = 'bg', highlight = 'Normal' },
          bold = true,
          italic = false,
        },
      },
    }
    vim.keymap.set('n', '<S-h>', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
    vim.keymap.set('n', '<S-l>', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
  end,
}
