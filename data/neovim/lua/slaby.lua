-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
require("sl_config.lazy")

require("sl_config.build")
require("sl_config.kernel")
require("sl_config.keymap")
require("sl_config.nohls")
require("sl_config.restore_cursor")
require("sl_config.skeletons")

vim.cmd.colorscheme("kanagawa")

vim.opt.listchars = {
  tab = '» ',
  --trail = '·',
  nbsp = '␣',
  --eol = '↲',
  space = '⋅',
}

-- port z vimrc

vim.o.autowrite = true
vim.o.cinoptions = ":0,(0"
-- vim.o.tags = "tags;/"
vim.g.c_space_errors = 1
