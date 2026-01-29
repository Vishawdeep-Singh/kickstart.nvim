return {
  'stevearc/oil.nvim',
  lazy = false,
  dependencies = {
    'antosha417/nvim-lsp-file-operations', -- Add this dependency
  },
  opts = {
    default_file_explorer = true,
    view_options = {
      show_hidden = true,
    },
    skip_confirm_for_simple_edits = true,
    prompt_save_on_select_new_entry = true,
    float = {
      padding = 2,
      max_width = 0.9,
      max_height = 0.9,
      border = 'rounded',
      win_options = {
        winblend = 10,
      },
    },
    -- This is important: Oil will now notify LSP about file operations
    watch_for_changes = true,
  },
  config = function(_, opts)
    local oil = require 'oil'
    oil.setup(opts)

    -- Hook into Oil's file operations to trigger LSP updates
    local lsp_file_operations = require 'lsp-file-operations'

    -- Override Oil's actions to notify LSP
    vim.api.nvim_create_autocmd('User', {
      pattern = 'OilEnter',
      callback = function()
        -- When Oil is opened, prepare for file operations
        lsp_file_operations.setup()
      end,
    })
  end,
}
