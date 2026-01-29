return {
  'zbirenbaum/copilot.lua',
  event = 'InsertEnter',
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = '<C-y>', -- Ctrl+y to accept suggestion (standard vim completion key)
        accept_word = '<M-w>',
        accept_line = '<M-l>',
        next = '<M-]>',
        prev = '<M-[>',
        dismiss = '<C-]>',
      },
    },
    panel = { enabled = false },
    filetypes = {
      yaml = true,
      markdown = true,
      help = false,
      gitcommit = true,
      gitrebase = false,
      ['.'] = true,
    },
  },
}
