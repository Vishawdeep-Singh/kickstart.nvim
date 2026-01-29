-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 100

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'
vim.o.guicursor = ''

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Auto-reload files when changed externally (e.g., by opencode)
vim.o.autoread = true

vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldenable = false
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
-- Fix blink.cmp highlights for GitHub Dark themes
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = 'github_*',
  callback = function()
    vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { bg = '#0d1117', fg = '#c9d1d9' })
    vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection', { bg = '#2f333b', fg = '#c9d1d9', bold = true })
    vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { fg = '#30363d' })
    vim.api.nvim_set_hl(0, 'BlinkCmpGhostText', { fg = '#7d8590', italic = true })
  end,
})

-- Apply highlights immediately if GitHub theme is already active
if vim.g.colors_name and vim.g.colors_name:match 'github_' then
  vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { bg = '#0d1117', fg = '#c9d1d9' })
  vim.api.nvim_set_hl(0, 'BlinkCmpMenuSelection', { bg = '#2f333b', fg = '#c9d1d9', bold = true })
  vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { fg = '#30363d' })
  vim.api.nvim_set_hl(0, 'BlinkCmpGhostText', { fg = '#7d8590', italic = true })
end

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>e', function()
  require('oil').toggle_float()
end, { desc = 'Toggle Oil (float)' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
local opts = { noremap = true, silent = true, desc = 'Exit Insert/Visual/Terminal mode' }

-- Exit Insert mode with 'jk'
vim.keymap.set('i', 'jk', '<Esc>', opts)

-- Exit Visual mode with 'jk'
vim.keymap.set('v', 'jk', '<Esc>', opts)

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Terminal mode window navigation for opencode
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>|', '<cmd>vsplit<cr>', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>-', '<cmd>split<cr>', { desc = 'Split window horizontally' })
vim.keymap.set({ 'n', 'x' }, '<leader>ca', function()
  require('tiny-code-action').code_action {}
end, { noremap = true, silent = true, desc = '[C]ode [A]ction' })

-- Merge conflict helper keymaps (Diffview)
vim.keymap.set('n', '<leader>mo', '<cmd>DiffviewOpen<cr>', { desc = '[M]erge: [O]pen diffview' })
vim.keymap.set('n', '<leader>mf', '<cmd>DiffviewFocusFiles<cr>', { desc = '[M]erge: [F]ocus files panel' })
vim.keymap.set('n', '<leader>mt', '<cmd>DiffviewToggleFiles<cr>', { desc = '[M]erge: [T]oggle files panel' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })
--
vim.keymap.set('v', '<leader>cf', function()
  local rel_path = vim.fn.fnamemodify(vim.fn.expand '%', ':.:r') -- Relative from cwd, no ext if needed
  local start, end_ = math.min(vim.fn.line 'v', vim.fn.line '.'), math.max(vim.fn.line 'v', vim.fn.line '.')
  vim.fn.setreg('+', '@' .. rel_path .. ':' .. start .. '-' .. end_)
  vim.notify('Copied: @' .. rel_path .. ':' .. start .. '-' .. end_)
end, { desc = 'Copy @file:start-end' })
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
-- Fix fold updates - this is the key fix
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter', 'BufWritePost' }, {
  pattern = '*',
  callback = function()
    -- Only update folds if treesitter is active
    if vim.bo.filetype ~= '' then
      vim.opt_local.foldmethod = 'expr'
      vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
    end
  end,
})

-- Force fold update after LSP attaches
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function()
    vim.defer_fn(function()
      vim.cmd 'normal! zx' -- Update folds
    end, 100)
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

  { import = 'kickstart.plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
