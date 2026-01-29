return {
  'stevearc/aerial.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('aerial').setup {
      -- Configure aerial options here
      backends = { 'treesitter', 'lsp', 'markdown', 'asciidoc', 'man' },
      layout = {
        default_direction = 'prefer_right',
      },
      -- Filter which symbol kinds to show

      filter_kind = {
        'Class',
        'Constructor',
        'Enum',
        'Function',
        'Interface',
        'Method',
        'Module',
        'Struct',
        'Variable',
        'Property', -- For object properties
        'Field', -- For class fields
        'Constant', -- For const declarations
      },
    }

    -- Load Aerial telescope extension
    require('telescope').load_extension 'aerial'

    -- Keymaps for Aerial
    vim.keymap.set('n', '<leader>cs', '<cmd>AerialToggle<CR>', { desc = '[C]ode [S]ymbols (Aerial)' })
    vim.keymap.set('n', '<leader>cS', '<cmd>Telescope aerial<CR>', { desc = '[C]ode [S]ymbols (Telescope)' })
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { desc = 'Jump to previous symbol' })
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { desc = 'Jump to next symbol' })
  end,
}
