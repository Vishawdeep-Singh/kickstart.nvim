return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  lazy = false,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },

  opts = function(_, opts)
    opts.ensure_installed = {
      'lua',
      'vim',
      'vimdoc',

      'json',
      'typescript',
      'tsx',

      'markdown',
      'markdown_inline',
    }

    opts.auto_install = true

    opts.highlight = {
      enable = true,
      additional_vim_regex_highlighting = { 'ruby' },
      disable = function(_, buf)
        local max_filesize = 200 * 1024
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        return ok and stats and stats.size > max_filesize
      end,
    }

    opts.indent = {
      enable = true,
      disable = { 'ruby' },
    }

    opts.textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
        },
      },
    }

    return opts
  end,

  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
  end,
}
