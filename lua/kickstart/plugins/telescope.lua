return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
  },
  config = function()
    local actions = require 'telescope.actions'
    local builtin = require 'telescope.builtin'

    local send_to_qf = {
      i = actions.send_selected_to_qflist + actions.open_qflist,
      n = actions.send_selected_to_qflist + actions.open_qflist,
    }

    require('telescope').setup {
      defaults = {
        debounce = 150,
        mappings = {
          i = {
            ['<C-q>'] = send_to_qf,
          },
          n = {
            ['<C-q>'] = send_to_qf,
          },
        },
      },
      pickers = {
        live_grep = {
          debounce = 150,
          mappings = {
            i = {
              ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
            },
            n = {
              ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
            },
          },
        },
        grep_string = {
          mappings = {
            i = {
              ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
            },
            n = {
              ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
            },
          },
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>sg', function()
      builtin.grep_string { search = vim.fn.input 'Grep > ' }
    end, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sW', function()
      builtin.grep_string { search = vim.fn.expand '<cWORD>' }
    end, { desc = '[S]earch current [W]ORD' })
    vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = '[G]it [F]iles' })
    vim.keymap.set('n', '<leader>sy', builtin.lsp_dynamic_workspace_symbols, { desc = '[S]earch s[Y]mbols (workspace)' })
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })

    vim.keymap.set('n', '<leader><leader>', function()
      builtin.buffers {
        sort_mru = true,
        ignore_current_buffer = true,
      }
    end, { desc = 'Switch buffers' })

    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in buffer' })
  end,
}
