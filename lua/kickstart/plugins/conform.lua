return {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
        {
            '<leader>f',
            function()
                require('conform').format { async = true, lsp_format = 'fallback' }
            end,
            desc = 'Format buffer',
        },
    },
    opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
            if vim.b[bufnr].large_file then
                return
            end
            return { timeout_ms = 2000, lsp_format = 'fallback' }
        end,
        formatters_by_ft = {
            lua = { 'stylua' },
            python = { 'ruff_format' },
            javascript = { 'prettier' },
            typescript = { 'prettier' },
            javascriptreact = { 'prettier' },
            typescriptreact = { 'prettier' },
            css = { 'prettier' },
            html = { 'prettier' },
            json = { 'prettier' },
            jsonc = { 'prettier' },
            yaml = { 'prettier' },
            markdown = { 'prettier' },
            graphql = { 'prettier' },
        },
    },
}
