-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("core.keymaps")
local lspconfig = require("lspconfig")
lspconfig.pyright.setup({})
vim.cmd.colorscheme("tokyonight-storm")
