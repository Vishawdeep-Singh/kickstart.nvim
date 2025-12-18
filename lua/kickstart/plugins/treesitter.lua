return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',

  opts = function(_, opts)
    -- 1️⃣ Default base opts table (your treesitter settings)
    opts.ensure_installed = {
      'bash',
      'c',
      'diff',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'vim',
      'vimdoc',
    }

    opts.auto_install = true

    opts.highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'ruby' },
    }

    opts.indent = {
      enable = true,
      disable = { 'ruby' },
    }

    opts.fold = {
      enable = true,
    }

    -- 2️⃣ Extra config logic (your theme / blink highlights)
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = 'github_*',
      callback = function()
        vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { bg = '#0d1117', fg = '#c9d1d9' })
        vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection', { bg = '#2f333b', fg = '#c9d1d9', bold = true })
        vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { fg = '#30363d' })
        vim.api.nvim_set_hl(0, 'BlinkCmpGhostText', { fg = '#7d8590', italic = true })
      end,
    })

    return opts
  end,

  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
  end,
}
