return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    -- blink.cmp instead of nvim-cmp
    {
      'saghen/blink.cmp',
      dependencies = 'rafamadriz/friendly-snippets',
      version = '*',
      opts = {
        keymap = {
          preset = 'default',
          ['<C-n>'] = { 'select_next', 'fallback' },
          ['<C-p>'] = { 'select_prev', 'fallback' },
          ['<CR>'] = { 'accept', 'fallback' },
          ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
          ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
          ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
          ['<Tab>'] = { 'select_next', 'fallback' },
          ['<S-Tab>'] = { 'select_prev', 'fallback' },
        },
        appearance = {
          use_nvim_cmp_as_default = true,
          nerd_font_variant = 'mono',
        },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        completion = {
          documentation = {
            auto_show = true,
            window = {
              border = 'rounded',
            },
          },
          menu = {
            border = 'rounded',
          },
        },
      },
      opts_extend = { 'sources.default' },
    },
    {
      'L3MON4D3/LuaSnip',
      dependencies = {
        'rafamadriz/friendly-snippets',
        config = function()
          require('luasnip.loaders.from_vscode').lazy_load()
        end,
      },
    },
    'j-hui/fidget.nvim',
  },
  config = function()
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    require('fidget').setup {}
    require('mason').setup()

    -- Better LSP hover and signature help with border (Neovim 0.12+)
    vim.o.winborder = 'rounded'

    -- Set up highlight groups for better differentiation
    local function set_highlights()
      -- Float window differentiation
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#26233a' })
      vim.api.nvim_set_hl(0, 'FloatBorder', { fg = '#6e6a86', bg = '#26233a' })
      vim.api.nvim_set_hl(0, 'FloatTitle', { fg = '#e0def4', bg = '#26233a', bold = true })
    end

    -- Apply highlights after colorscheme loads
    vim.api.nvim_create_autocmd('ColorScheme', {
      pattern = '*',
      callback = set_highlights,
    })
    set_highlights()

    -- Document Highlight: Only in Normal mode (no Insert mode lag)
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

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- Document Highlight: Only in Normal mode (CursorHold), NOT Insert mode
        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          -- Only in Normal mode - NO CursorHoldI to prevent typing lag
          vim.api.nvim_create_autocmd('CursorHold', {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd('CursorMoved', {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            end,
          })
        end

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

  end,
}
