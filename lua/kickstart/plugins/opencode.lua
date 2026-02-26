return {
  'nickjvandyke/opencode.nvim',
  version = '*', -- Latest stable release

  dependencies = {
    {
      'folke/snacks.nvim',
      optional = true,
      opts = {
        input = {},

        picker = {
          actions = {
            opencode_send = function(...)
              return require('opencode').snacks_picker_send(...)
            end,
          },
          win = {
            input = {
              keys = {
                ['<a-a>'] = { 'opencode_send', mode = { 'n', 'i' } },
              },
            },
          },
        },

        terminal = {},
      },
    },
  },

  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Use new reload system instead of old auto_reload
      events = {
        reload = true,
      },
    }

    -- Required for reload
    vim.o.autoread = true

    -- =========================
    -- Your Existing Keymaps
    -- =========================

    vim.keymap.set({ 'n', 'x' }, '<leader>oa', function()
      require('opencode').ask('@this: ', { submit = true })
    end, { desc = 'Ask about this' })

    vim.keymap.set({ 'n', 'x' }, '<leader>os', function()
      require('opencode').select()
    end, { desc = 'Select prompt' })

    vim.keymap.set({ 'n', 'x' }, '<leader>o+', function()
      require('opencode').prompt '@this'
    end, { desc = 'Add this' })

    vim.keymap.set('n', '<leader>ot', function()
      require('opencode').toggle()
    end, { desc = 'Toggle embedded' })

    vim.keymap.set('n', '<leader>oc', function()
      require('opencode').command()
    end, { desc = 'Select command' })

    vim.keymap.set('n', '<leader>on', function()
      require('opencode').command 'session.new'
    end, { desc = 'New session' })

    vim.keymap.set('n', '<leader>oi', function()
      require('opencode').command 'session.interrupt'
    end, { desc = 'Interrupt session' })

    vim.keymap.set('n', '<leader>oA', function()
      require('opencode').command 'agent.cycle'
    end, { desc = 'Cycle selected agent' })

    -- Updated to new command format
    vim.keymap.set('n', '<S-C-u>', function()
      require('opencode').command 'session.half.page.up'
    end, { desc = 'Messages half page up' })

    vim.keymap.set('n', '<S-C-d>', function()
      require('opencode').command 'session.half.page.down'
    end, { desc = 'Messages half page down' })
  end,
}
