local M = {
  { -- You can easily change to a different colorscheme.
    -- Change the name of the colorscheme plugin below, and then
    -- change the command in the config to whatever the name of that colorscheme is.
    --
    -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'folke/tokyonight.nvim',
    priority = 1000,
    config = function()
      local transparent = true -- set to true if you would like to enable transparency

      -- vim.cmd.colorscheme 'tokyonight'
      local bg = '#011628'
      local bg_dark = '#011423'
      local bg_highlight = '#143652'
      local bg_search = '#0A64AC'
      local bg_visual = '#275378'
      local fg = '#CBE0F0'
      local fg_dark = '#B4D0E9'
      local fg_gutter = '#627E97'
      local border = '#547998'

      require('tokyonight').setup {
        style = 'night',
        transparent = transparent,
        styles = {
          sidebars = transparent and 'transparent' or 'dark',
          floats = transparent and 'transparent' or 'dark',
        },
        on_colors = function(colors)
          colors.bg = bg
          colors.bg_dark = transparent and colors.none or bg_dark
          colors.bg_float = transparent and colors.none or bg_dark
          colors.bg_highlight = bg_highlight
          colors.bg_popup = bg_dark
          colors.bg_search = bg_search
          colors.bg_sidebar = transparent and colors.none or bg_dark
          colors.bg_statusline = transparent and colors.none or bg_dark
          colors.bg_visual = bg_visual
          colors.border = border
          colors.fg = fg
          colors.fg_dark = fg_dark
          colors.fg_float = fg
          colors.fg_gutter = fg_gutter
          colors.fg_sidebar = fg_dark
        end,
        on_highlights = function(highlights, colors)
          -- Optional: customize highlights here
          -- Editor UI improvements
          highlights.NormalFloat = { bg = colors.bg_dark, fg = colors.fg }
          highlights.FloatBorder = { bg = colors.bg_dark, fg = colors.border }
          highlights.CursorLineNr = { fg = colors.fg, bg = colors.bg_highlight }
          highlights.LineNr = { fg = colors.fg_gutter }
          highlights.LineNrAbove = { fg = colors.fg_gutter }
          highlights.LineNrBelow = { fg = colors.fg_gutter }

          -- Search and selection
          highlights.Search = { bg = colors.bg_search, fg = colors.fg }
          highlights.IncSearch = { bg = colors.bg_search, fg = colors.fg_dark }
          highlights.Visual = { bg = colors.bg_visual, fg = colors.fg }

          -- Telescope (fuzzy finder)
          highlights.TelescopeNormal = { bg = colors.bg_dark, fg = colors.fg_dark }
          highlights.TelescopeBorder = { bg = colors.bg_dark, fg = colors.border }
          highlights.TelescopeSelection = { bg = colors.bg_highlight, fg = colors.fg }
          highlights.TelescopeSelectionCaret = { bg = colors.bg_highlight, fg = colors.fg }

          -- LSP and diagnostics
          highlights.DiagnosticVirtualTextError = { bg = colors.none, fg = colors.red }
          highlights.DiagnosticVirtualTextWarn = { bg = colors.none, fg = colors.yellow }
          highlights.DiagnosticVirtualTextInfo = { bg = colors.none, fg = colors.blue }
          highlights.DiagnosticVirtualTextHint = { bg = colors.none, fg = colors.teal }

          -- Statusline and sidebar
          highlights.StatusLine = { bg = colors.bg_statusline, fg = colors.fg_sidebar }
          highlights.NvimTreeNormal = { bg = colors.bg_sidebar, fg = colors.fg_sidebar }
          highlights.NvimTreeIndentMarker = { fg = colors.border }

          -- Git signs (if using gitsigns.nvim)
          highlights.GitSignsAdd = { fg = colors.green }
          highlights.GitSignsChange = { fg = colors.blue }
          highlights.GitSignsDelete = { fg = colors.red }

          -- Diffview colors (VS Code style)
          highlights.DiffAdd = { fg = 'NONE', bg = '#003300' }
          highlights.DiffDelete = { fg = 'NONE', bg = '#330000' }
          highlights.DiffChange = { fg = 'NONE', bg = '#003344' }
          highlights.DiffText = { fg = 'NONE', bg = '#005577' }
        end,
      }

      -- vim.cmd 'colorscheme tokyonight'
    end,
  },

  {
    'sainnhe/everforest',
    lazy = false,
    config = function()
      -- Optionally configure and load the colorscheme
      -- directly inside the plugin declaration.
      vim.g.everforest_background = 'hard'
      vim.g.everforest_enable_italic = true

      -- Fix ghost text color for autocompletion suggestions
      -- Set it to a dim gray color similar to Tokyo Night's ghost text
      vim.api.nvim_set_hl(0, 'BlinkCmpGhostText', { fg = '#5a6474', italic = true })

      -- Fix diagnostic colors to be more visible instead of gray
      vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextWarn', { fg = '#d4a520', italic = true })
      vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', { fg = '#e67e80', italic = true })
      vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextInfo', { fg = '#7fbbb3', italic = true })
      vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextHint', { fg = '#83a598', italic = true })
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    priority = 1000,
    config = function() end,
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {}

      vim.api.nvim_set_hl(0, 'BlinkCmpItemAbbr', { fg = '#7d8590' })
      vim.api.nvim_set_hl(0, 'BlinkCmpItemAbbrMatch', { fg = '#9da5b4', bold = true })
      vim.api.nvim_set_hl(0, 'BlinkCmpItemKind', { fg = '#7d8590' })
      vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { fg = '#30363d' })
      vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { bg = '#0d1117', fg = '#c9d1d9' })
      vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection', { bg = '#2f333b', fg = '#c9d1d9', bold = true })
      vim.api.nvim_set_hl(0, 'BlinkCmpGhostText', { fg = '#7d8590', italic = true })
    end,
  },
  -- lua/plugins/rose-pine.lua
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'rose-pine'
    end,
  },
  {
    'projekt0n/github-nvim-theme',
    name = 'github-theme',
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('github-theme').setup {
        -- ...
      }

      -- Fix blink.cmp highlights for GitHub Dark theme
      vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { bg = '#0d1117', fg = '#c9d1d9' })
      vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection', { bg = '#2f333b', fg = '#c9d1d9', bold = true })
      vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { fg = '#30363d' })
      vim.api.nvim_set_hl(0, 'BlinkCmpGhostText', { fg = '#7d8590', italic = true })
    end,
  },

  {
    'Mofiqul/vscode.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('vscode').setup {
        transparent = true,
        italic_comments = true,
        disable_nvimtree_bg = true,
      }
    end,
  },
  -- {
  --   'ydkulks/cursor-dark.nvim',
  --   lazy = false,
  --   priority = 1001,
  --   config = function()
  --     vim.cmd.colorscheme 'cursor-dark-midnight'
  --     require('cursor-dark').setup {
  --       -- For theme
  --       transparent = true,
  --       style = 'dark-midnight',
  --     }
  --
  --     -- Fix matching parentheses/brackets highlighting to prevent reverse cursor block
  --     vim.api.nvim_set_hl(0, 'MatchParen', {
  --       bg = '#3e4451', -- Subtle background highlight
  --       fg = '#61afef', -- Blue foreground for the matching character
  --       bold = true, -- Make it bold for visibility
  --       reverse = false, -- Prevent reverse video mode
  --     })
  --   end,
  -- },
}
return M
