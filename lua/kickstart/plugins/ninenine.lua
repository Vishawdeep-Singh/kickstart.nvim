return {
  'ThePrimeagen/99',
  dependencies = {
    'nvim-telescope/telescope.nvim',
    {
      'saghen/blink.compat',
      version = '2.*',
    },
  },
  config = function()
    local _99 = require '99'

    local cwd = vim.uv.cwd()
    local basename = vim.fs.basename(cwd)

    _99.setup {
      provider = _99.Providers.CursorAgentProvider,
      model = 'composer-2.5-fast',
      show_in_flight_requests = true,
      tmp_dir = './tmp',
      md_files = { 'AGENTS.md', 'AGENT.md' },
      auto_add_skills = true,
      logger = {
        level = _99.DEBUG,
        path = '/tmp/' .. basename .. '.99.debug',
        print_on_error = true,
      },
      completion = {
        source = 'blink',
        custom_rules = {
          '~/.agents/skills/',
        },
        files = {
          enabled = true,
        },
      },
      display_errors = true,
    }

    vim.keymap.set('v', '<leader>9v', function()
      _99.visual()
    end, { desc = '99: Visual selection AI' })

    vim.keymap.set('v', '<leader>9vv', function()
      _99.visual()
    end, { desc = '99: Visual' })

    vim.keymap.set('v', '<leader>9vp', function()
      _99.visual_prompt()
    end, { desc = '99: Visual prompt' })

    vim.keymap.set('n', '<leader>9s', function()
      _99.search()
    end, { desc = '99: Search with AI' })

    vim.keymap.set('n', '<leader>9x', function()
      _99.stop_all_requests()
    end, { desc = '99: Stop all' })

    vim.keymap.set('n', '<leader>9i', function()
      _99.info()
    end, { desc = '99: Info' })

    vim.keymap.set('n', '<leader>9l', function()
      _99.view_logs()
    end, { desc = '99: Logs' })

    vim.keymap.set('n', '<leader>9n', function()
      _99.next_request_logs()
    end, { desc = '99: Next log' })

    vim.keymap.set('n', '<leader>9p', function()
      _99.prev_request_logs()
    end, { desc = '99: Prev log' })

    vim.keymap.set('n', '<leader>9t', function()
      _99.tutorial()
    end, { desc = '99: Tutorial' })

    vim.keymap.set('n', '<leader>9m', function()
      require('99.extensions.telescope').select_model()
    end, { desc = '99: Select AI model' })

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

    local Worker = _99.Extensions.Worker

    vim.keymap.set('n', '<leader>9w', function()
      Worker.set_work()
    end, { desc = '99: Set work item' })

    vim.keymap.set('n', '<leader>9W', function()
      Worker.search()
    end, { desc = '99: Search what is left for work item' })
  end,
}
