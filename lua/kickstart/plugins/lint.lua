return {
  'mfussenegger/nvim-lint',
  event = {
    { 'BufEnter', 'BufWritePost', 'InsertLeave' },
  },
  config = function()
    local lint = require 'lint'

    lint.linters_by_ft = {
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
      svelte = { 'eslint_d' },
      python = { 'pylint' },
    }

    -- Configure eslint_d to use stdin for real-time linting (works with unsaved buffer content)
    -- This also supports monorepos and .mjs configs
    lint.linters.eslint_d.stdin = true
    lint.linters.eslint_d.args = {
      '--no-warn-ignored',
      '--format',
      'json',
      '--stdin',
      '--stdin-filename',
      function()
        return vim.api.nvim_buf_get_name(0)
      end,
    }

    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        -- Find the project root for monorepo support
        local root = vim.fs.root(0, {
          'eslint.config.js',
          'eslint.config.mjs',
          'eslint.config.cjs',
          '.eslintrc.js',
          '.eslintrc.mjs',
          '.eslintrc.cjs',
          '.eslintrc.json',
          'package.json',
        })

        if root then
          lint.try_lint(nil, { cwd = root })
        else
          lint.try_lint()
        end
      end,
    })

    vim.keymap.set('n', '<leader>l', function()
      -- Find the project root for monorepo support
      local root = vim.fs.root(0, {
        'eslint.config.js',
        'eslint.config.mjs',
        'eslint.config.cjs',
        '.eslintrc.js',
        '.eslintrc.mjs',
        '.eslintrc.cjs',
        '.eslintrc.json',
        'package.json',
      })

      if root then
        lint.try_lint(nil, { cwd = root })
      else
        lint.try_lint()
      end
    end, { desc = 'Trigger linting for current file' })
  end,
}
