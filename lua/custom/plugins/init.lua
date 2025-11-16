-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- Explicitly setup nvim-web-devicons for better file icons
  {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup({
        override = {},
        default = true,
        strict = true,
        override_by_filename = {
          ['.gitignore'] = {
            icon = '',
            color = '#f1502f',
            name = 'Gitignore',
          },
        },
        override_by_extension = {
          ['svg'] = {
            icon = '󰜡',
            color = '#FFB13B',
            name = 'Svg',
          },
        },
      })
    end,
  },
}
