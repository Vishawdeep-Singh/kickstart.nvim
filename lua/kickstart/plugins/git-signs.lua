return { -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    word_diff = false, -- Can be toggled with keymap
    current_line_blame = false, -- Can be toggled with keymap
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'

      local function map(mode, l, r, map_opts)
        map_opts = map_opts or {}
        map_opts.buffer = bufnr
        vim.keymap.set(mode, l, r, map_opts)
      end

      map('n', '<leader>gb', function()
        gitsigns.blame_line { full = true }
      end, { desc = '[G]it [B]lame line' })

      map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = '[G]it [T]oggle line [B]lame' })

      map('n', '<leader>td', gitsigns.toggle_signs, { desc = '[T]oggle [D]iff signs (git hunks)' })

      map('n', '<leader>tw', gitsigns.toggle_word_diff, { desc = '[T]oggle [W]ord diff (inline red/green)' })

      map('n', '<leader>gd', gitsigns.diffthis, { desc = '[G]it [D]iff buffer' })

      -- Toggle inline diff view with syntax highlighting
      map('n', '<leader>tD', function()
        if vim.wo.diff then
          vim.cmd 'diffoff'
        else
          gitsigns.diffthis()
        end
      end, { desc = '[T]oggle [D]iff view (inline)' })

      -- Toggle split diff view for clearer comparison
      map('n', '<leader>tS', function()
        if vim.wo.diff then
          vim.cmd 'diffoff'
        else
          vim.cmd 'Gitsigns diffthis ~'
        end
      end, { desc = '[T]oggle [S]plit diff view' })

      map('n', '<leader>gD', function()
        gitsigns.diffthis '~'
      end, { desc = '[G]it [D]iff buffer against last commit' })

      map('n', '<leader>gp', gitsigns.preview_hunk, { desc = '[G]it [P]review hunk' })

      map('n', '<leader>gr', gitsigns.reset_hunk, { desc = '[G]it [R]eset hunk' })
      map('v', '<leader>gr', function()
        gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = '[G]it [R]eset hunk' })

      map('n', '<leader>gR', gitsigns.reset_buffer, { desc = '[G]it [R]eset buffer' })

      map('n', '<leader>gs', gitsigns.stage_hunk, { desc = '[G]it [S]tage hunk' })
      map('v', '<leader>gs', function()
        gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = '[G]it [S]tage hunk' })

      map('n', '<leader>gS', gitsigns.stage_buffer, { desc = '[G]it [S]tage buffer' })

      map('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = '[G]it [U]ndo stage hunk' })

      map('n', ']h', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          gitsigns.nav_hunk 'next'
        end
      end, { desc = 'Jump to next git hunk' })

      map('n', '[h', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          gitsigns.nav_hunk 'prev'
        end
      end, { desc = 'Jump to previous git hunk' })
    end,
  },
}
