return {
  'ThePrimeagen/99',
  dependencies = {
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    local _99 = require '99'

    local cwd = vim.uv.cwd()
    local basename = vim.fs.basename(cwd)

    _99.setup {
      -- Use OpenCode as the AI provider (default)
      -- Options: OpenCodeProvider, ClaudeCodeProvider, CursorAgentProvider, GeminiCLIProvider
      provider = _99.Providers.OpenCodeProvider,

      model = 'opencode-go/kimi-k2.5',

      -- Temporary directory for AI processing (MUST be inside project CWD for permissions)
      tmp_dir = './tmp',

      -- Auto-load AGENT.md files from project directories
      md_files = { 'AGENT.md' },

      -- Enable auto-add skills
      auto_add_skills = true,

      -- Logging configuration (for debugging)
      logger = {
        level = _99.DEBUG,
        path = '/tmp/' .. basename .. '.99.debug',
        print_on_error = true,
      },

      -- Completion settings for #rules and @files
      completion = {
        -- Autocomplete source: 'native' (default), 'cmp', or 'blink'
        source = 'native',

        -- Custom rules directories (each containing SKILL.md files)
        custom_rules = {},

        -- File reference settings (@files)
        files = {
          enabled = true,
        },
      },

      -- Display errors in UI
      display_errors = true,
    }

    -- ==========================================
    -- KEYMAPS (Traditional 99 prompt buffer)
    -- ==========================================

    -- Visual mode: Send selection to AI for replacement
    vim.keymap.set('v', '<leader>9v', function()
      _99.visual()
    end, { desc = '99: Visual selection AI' })

    -- Search across project with AI analysis
    vim.keymap.set('n', '<leader>9s', function()
      _99.search()
    end, { desc = '99: Search with AI' })

    -- Tutorial from AI
    vim.keymap.set('n', '<leader>9t', function()
      _99.tutorial()
    end, { desc = '99: Tutorial' })

    -- Telescope model selector
    vim.keymap.set('n', '<leader>9m', function()
      require('99.extensions.telescope').select_model()
    end, { desc = '99: Select AI model' })

    -- Telescope tutorial picker
    vim.keymap.set('n', '<leader>9T', function()
      local ok, pickers = pcall(require, 'telescope.pickers')
      if not ok then
        vim.notify('99: telescope.nvim is required', vim.log.levels.ERROR)
        return
      end

      local finders = require 'telescope.finders'
      local conf = require('telescope.config').values
      local actions = require 'telescope.actions'
      local action_state = require 'telescope.actions.state'

      local state = _99.__get_state()
      local tutorials = state:get_request_data_by_type 'tutorial'

      if #tutorials == 0 then
        vim.notify('99: No tutorials in this session', vim.log.levels.INFO)
        return
      end

      local entries = {}
      for _, t in ipairs(tutorials) do
        table.insert(entries, {
          display = t.tutorial[1] or ('Tutorial #' .. t.xid),
          xid = t.xid,
        })
      end

      pickers
        .new({}, {
          prompt_title = '99: Open Tutorial',
          finder = finders.new_table {
            results = entries,
            entry_maker = function(e)
              return { value = e, display = e.display, ordinal = e.display }
            end,
          },
          sorter = conf.generic_sorter {},
          attach_mappings = function(prompt_bufnr)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local sel = action_state.get_selected_entry()
              if sel then
                _99.open_tutorial(sel.value.xid)
              end
            end)
            return true
          end,
        })
        :find()
    end, { desc = '99: Open tutorial (telescope)' })

    -- ==========================================
    -- WORK (task tracker + AI search)
    -- ==========================================
    local Worker = _99.Extensions.Worker

    vim.keymap.set('n', '<leader>9w', function()
      Worker.set_work()
    end, { desc = '99: Set work item' })

    vim.keymap.set('n', '<leader>9W', function()
      Worker.search()
    end, { desc = '99: Search what is left for work item' })

    -- ==========================================
    -- CUSTOM COMMANDS
    -- ==========================================
  end,
}
