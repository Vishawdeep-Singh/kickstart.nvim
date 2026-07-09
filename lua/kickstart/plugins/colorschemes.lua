local function ColorMyPencils(color)
  color = color or 'rose-pine-moon'
  vim.cmd('colorscheme ' .. color)
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
end

local M = {
  {
    'erikbackman/brightburn.vim',
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      style = 'night',
      transparent = true,
      terminal_colors = true,
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        sidebars = 'dark',
        floats = 'dark',
      },
    },
    config = function(_, opts)
      require('tokyonight').setup(opts)
    end,
  },
  {
    'ellisonleao/gruvbox.nvim',
    name = 'gruvbox',
    config = function()
      require('gruvbox').setup {
        terminal_colors = true,
        undercurl = true,
        underline = false,
        bold = true,
        italic = {
          strings = false,
          emphasis = false,
          comments = false,
          operators = false,
          folds = false,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        invert_intend_guides = false,
        inverse = true,
        contrast = '',
        palette_overrides = {},
        overrides = {},
        dim_inactive = false,
        transparent_mode = false,
      }
    end,
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      require('rose-pine').setup {
        disable_background = true,
        styles = {
          italic = false,
        },
      }
      ColorMyPencils('rose-pine-moon')
    end,
  },
}
return M
