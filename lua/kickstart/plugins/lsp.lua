return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'mason-org/mason.nvim',
    'mason-org/mason-lspconfig.nvim',
    -- blink.cmp instead of nvim-cmp
    {
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
              end,
            },
          },
          opts = {},
        },
      },
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      opts = {
        snippets = {
          preset = 'luasnip',
        },

        appearance = {
          use_nvim_cmp_as_default = false,
          nerd_font_variant = 'mono',
        },

        completion = {
          accept = {
            auto_brackets = {
              enabled = true,
            },
          },
          menu = {
            draw = {
              treesitter = { 'lsp' },
            },
          },
          documentation = {
            auto_show = false,
            auto_show_delay_ms = 500,
          },
          ghost_text = {
            enabled = vim.g.ai_cmp,
          },
        },

        signature = { enabled = true },

        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        cmdline = {
          enabled = true,
          keymap = {
            preset = 'cmdline',
            ['<Right>'] = false,
            ['<Left>'] = false,
          },
          completion = {
            list = { selection = { preselect = false } },
            menu = {
              auto_show = function(ctx)
                return vim.fn.getcmdtype() == ':'
              end,
            },
            ghost_text = { enabled = true },
          },
        },

        keymap = {
          preset = 'default',
          ['<C-y>'] = false,
          ['<Tab>'] = false,
          ['<S-Tab>'] = { 'select_prev', 'fallback' },
          ['<CR>'] = { 'accept', 'fallback' },
        },

        fuzzy = {
          implementation = 'prefer_rust_with_warning',
        },
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

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        vim.diagnostic.config { virtual_text = false, signs = true, underline = false }

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

        if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

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
