return { -- Autocompletion
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',
  dependencies = {
    -- Snippet Engine
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        -- Build Step is needed for regex support in snippets.
        -- This step is not supported in many windows environments.
        -- Remove the below condition to re-enable on windows.
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()

            local luasnip = require 'luasnip'
            luasnip.filetype_extend('typescriptreact', { 'html' })
            luasnip.filetype_extend('javascriptreact', { 'html' })
            luasnip.filetype_extend('typescript', { 'javascript' })
          end,
        },
      },
      opts = {
        history = true,
        delete_check_events = 'TextChanged',
      },
    },
    'folke/lazydev.nvim',
    {
      'saghen/blink.compat',
      version = '*',
      lazy = true,
      opts = {},
    },
  },
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    enabled = function()
      return not vim.b.large_file
    end,
    keymap = {
      -- 'default' (recommended) for mappings similar to built-in completions
      --   <c-y> to accept ([y]es) the completion.
      --    This will auto-import if your LSP supports it.
      --    This will expand snippets if the LSP sent a snippet.
      -- 'super-tab' for tab to accept
      -- 'enter' for enter to accept
      -- 'none' for no mappings
      --
      -- For an understanding of why the 'default' preset is recommended,
      -- you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      --
      -- All presets have the following mappings:
      -- <tab>/<s-tab>: move to right/left of your snippet expansion
      -- <c-space>: Open menu or open docs if already open
      -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
      -- <c-e>: Hide menu
      -- <c-k>: Toggle signature help
      --
      -- See :h blink-cmp-config-keymap for defining your own keymap
      preset = 'enter',

      -- Add Tab for accepting completions (works when completion menu is open)
      ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },

      ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },

      -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
      --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
    },

    accept = { auto_brackets = { enabled = true } },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = 'mono',
    },

    completion = {
      -- Auto-show documentation like VS Code for better context
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      menu = {
        border = 'rounded',
        draw = {
          columns = { { 'kind_icon' }, { 'label', 'label_description', gap = 1 }, { 'kind' } },
          components = {
            kind_icon = {
              text = function(ctx)
                local mini_icons = require 'mini.icons'
                local icon, hl = mini_icons.get('lsp', ctx.kind)
                return icon .. ' ', hl
              end,
            },
          },
        },
      },
      ghost_text = { enabled = true },
    },

    -- Custom highlights for better visibility
    -- highlight = {
    --   use_nvim_cmp_as_default = false,
    --   sets = {
    --     default = {
    --       ['ghost_text'] = { link = 'Comment' },
    --       ['menu'] = { bg = 'NONE' },
    --       ['menu_selection'] = { bg = '#2f333b', fg = '#c9d1d9' },
    --       ['menu_border'] = { fg = '#30363d' },
    --       ['scrollbar_thumb'] = { bg = '#30363d' },
    --     },
    --   },
    -- },
    --
    sources = {
      default = { 'lsp', 'path', 'snippets', 'copilot', 'buffer', 'lazydev' },
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        copilot = {
          name = 'copilot',
          module = 'blink.compat.source',
          score_offset = 90,
          async = true,
          opts = {},
        },
        buffer = {
          module = 'blink.cmp.sources.buffer',
          opts = {
            max_items = 5,
            min_keyword_length = 3,
          },
        },
      },
    },

    snippets = { preset = 'luasnip' },

    -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
    -- which automatically downloads a prebuilt binary when enabled.
    --
    -- By default, we use the Lua implementation instead, but you may enable
    -- the rust implementation via `'prefer_rust_with_warning'`
    --
    -- See :h blink-cmp-config-fuzzy for more information
    fuzzy = { implementation = 'prefer_rust_with_warning' }, -- Changed to rust for better performance

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
  },
}
