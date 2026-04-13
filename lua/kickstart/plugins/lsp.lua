return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    {
      'L3MON4D3/LuaSnip',
      dependencies = {
        'rafamadriz/friendly-snippets',
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
        end,
      },
    },
    'saadparwaiz1/cmp_luasnip',
    'j-hui/fidget.nvim',
  },
  config = function()
    local cmp = require 'cmp'
    local cmp_lsp = require 'cmp_nvim_lsp'
    local capabilities = vim.tbl_deep_extend('force', {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())
    require('fidget').setup {}
    require('mason').setup()

    -- Better LSP hover documentation with border
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = 'rounded',
      max_width = 80,
      max_height = 20,
    })

    -- Better LSP signature help with border
    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = 'rounded',
      max_width = 80,
      max_height = 20,
    })

    -- Set up highlight groups for better differentiation
    local function set_highlights()
      -- Float window differentiation
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#26233a' })
      vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#6e6a86', bg = '#26233a' })
      vim.api.nvim_set_hl(0, 'FloatTitle', { fg = '#e0def4', bg = '#26233a', bold = true })

      -- nvim-cmp highlights for better visibility
      vim.api.nvim_set_hl(0, 'CmpItemAbbr', { fg = '#e0def4' })
      vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { fg = '#6e6a86', strikethrough = true })
      vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { fg = '#ebbcba', bold = true })
      vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { fg = '#ebbcba', bold = true })
      vim.api.nvim_set_hl(0, 'CmpItemMenu', { fg = '#9ccfd8', italic = true })

      -- Cmp item kinds with rose-pine colors
      vim.api.nvim_set_hl(0, 'CmpItemKindText', { fg = '#e0def4' })
      vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { fg = '#ebbcba' })
      vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { fg = '#ebbcba' })
      vim.api.nvim_set_hl(0, 'CmpItemKindConstructor', { fg = '#c4a7e7' })
      vim.api.nvim_set_hl(0, 'CmpItemKindField', { fg = '#9ccfd8' })
      vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { fg = '#e0def4' })
      vim.api.nvim_set_hl(0, 'CmpItemKindClass', { fg = '#f6c177' })
      vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { fg = '#f6c177' })
      vim.api.nvim_set_hl(0, 'CmpItemKindModule', { fg = '#9ccfd8' })
      vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { fg = '#9ccfd8' })
      vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { fg = '#f6c177' })
      vim.api.nvim_set_hl(0, 'CmpItemKindValue', { fg = '#f6c177' })
      vim.api.nvim_set_hl(0, 'CmpItemKindEnum', { fg = '#f6c177' })
      vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { fg = '#31748f' })
      vim.api.nvim_set_hl(0, 'CmpItemKindSnippet', { fg = '#c4a7e7' })
      vim.api.nvim_set_hl(0, 'CmpItemKindColor', { fg = '#f6c177' })
      vim.api.nvim_set_hl(0, 'CmpItemKindFile', { fg = '#e0def4' })
      vim.api.nvim_set_hl(0, 'CmpItemKindReference', { fg = '#e0def4' })
      vim.api.nvim_set_hl(0, 'CmpItemKindFolder', { fg = '#e0def4' })
      vim.api.nvim_set_hl(0, 'CmpItemKindEnumMember', { fg = '#f6c177' })
      vim.api.nvim_set_hl(0, 'CmpItemKindConstant', { fg = '#f6c177' })
      vim.api.nvim_set_hl(0, 'CmpItemKindStruct', { fg = '#9ccfd8' })
      vim.api.nvim_set_hl(0, 'CmpItemKindEvent', { fg = '#eb6f92' })
      vim.api.nvim_set_hl(0, 'CmpItemKindOperator', { fg = '#908caa' })
      vim.api.nvim_set_hl(0, 'CmpItemKindTypeParameter', { fg = '#9ccfd8' })

      -- Selection highlight
      vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#44415a', fg = '#e0def4', bold = true })
      vim.api.nvim_set_hl(0, 'Pmenu', { bg = '#1f1d2e' })
      vim.api.nvim_set_hl(0, 'PmenuSbar', { bg = '#1f1d2e' })
      vim.api.nvim_set_hl(0, 'PmenuThumb', { bg = '#6e6a86' })
    end

    -- Apply highlights after colorscheme loads
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = '*',
      callback = set_highlights,
    })
    set_highlights()

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end
        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
        map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
        map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
        map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
        local function client_supports_method(client, method, bufnr)
          if vim.fn.has 'nvim-0.11' == 1 then
            return client:supports_method(method, bufnr)
          else
            return client.supports_method(method, { bufnr = bufnr })
          end
        end
        -- DISABLED: Document highlight on cursor hold - causes typing lag
        -- local client = vim.lsp.get_client_by_id(event.data.client_id)
        -- if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
        --   local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        --   vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        --     buffer = event.buf,
        --     group = highlight_augroup,
        --     callback = vim.lsp.buf.document_highlight,
        --   })
        --   vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        --     buffer = event.buf,
        --     group = highlight_augroup,
        --     callback = vim.lsp.buf.clear_references,
        --   })
        --   vim.api.nvim_create_autocmd('LspDetach', {
        --     group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        --     callback = function(event2)
        --       vim.lsp.buf.clear_references()
        --       vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
        --     end,
        --   })
        -- end
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    vim.diagnostic.config {
      severity_sort = true,
      float = {
        focusable = false,
        style = 'minimal',
        border = 'rounded',
        source = 'if_many',
        header = '',
        prefix = '',
      },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = ' ',
          [vim.diagnostic.severity.WARN] = ' ',
          [vim.diagnostic.severity.INFO] = ' ',
          [vim.diagnostic.severity.HINT] = ' ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
          local diagnostic_message = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return diagnostic_message[diagnostic.severity]
        end,
      },
    }

    local servers = {
      pyright = {
        settings = {
          python = {
            analysis = {
              typeCheckingMode = 'standard',
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = 'openFilesOnly',
            },
          },
        },
      },
      ruff = {
        init_options = {
          settings = {
            args = {},
          },
        },
      },
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
          },
        },
      },
    }

    require('mason-lspconfig').setup {
      ensure_installed = {
        'lua_ls',
        'rust_analyzer',
        'gopls',
        'vtsls',
        'tailwindcss',
        'pyright',
        'ruff',
        'zls',
      },
      automatic_installation = false,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
        zls = function()
          local lspconfig = require 'lspconfig'
          lspconfig.zls.setup {
            root_dir = lspconfig.util.root_pattern('.git', 'build.zig', 'zls.json'),
            settings = {
              zls = {
                enable_inlay_hints = true,
                enable_snippets = true,
                warn_style = true,
              },
            },
          }
          vim.g.zig_fmt_parse_errors = 0
          vim.g.zig_fmt_autosave = 0
        end,
        ['lua_ls'] = function()
          local lspconfig = require 'lspconfig'
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = {
                  version = 'LuaJIT',
                },
                diagnostics = {
                  globals = { 'vim' },
                },
                workspace = {
                  library = vim.api.nvim_get_runtime_file('', true),
                  checkThirdParty = false,
                },
                completion = {
                  callSnippet = 'Replace',
                },
                format = {
                  enable = true,
                  defaultConfig = {
                    indent_style = 'space',
                    indent_size = '2',
                  },
                },
              },
            },
          }
        end,
        ['tailwindcss'] = function()
          local lspconfig = require 'lspconfig'
          lspconfig.tailwindcss.setup {
            capabilities = capabilities,
            filetypes = {
              'html',
              'css',
              'scss',
              'javascript',
              'javascriptreact',
              'typescript',
              'typescriptreact',
              'vue',
              'svelte',
              'heex',
            },
          }
        end,
      },
    }

    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    cmp.setup {
      window = {
        completion = cmp.config.window.bordered {
          border = 'rounded',
          winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
        },
        documentation = cmp.config.window.bordered {
          border = 'rounded',
          winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
          max_width = 80,
          max_height = 20,
        },
      },
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert {
        ['<CR>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.confirm { select = true }
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        -- ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item(cmp_select)
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item(cmp_select)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = {
        { name = 'nvim_lsp', group_index = 1, priority = 100 },
        { name = 'luasnip', group_index = 1, priority = 90 },
        { name = 'path', group_index = 1, priority = 80 },
        { name = 'buffer', group_index = 2, priority = 50 },
      },
    }
    cmp.setup.cmdline({ '/', '?' }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = { { name = 'buffer' } },
    })
    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } }),
    })
  end,
}
