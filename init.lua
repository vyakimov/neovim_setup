-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup" }

local lspconfig = require("lspconfig")
lspconfig.pyright.setup({
  on_attach = function(client, bufnr)
    vim.keymap.set("i", "<C-Space>", vim.lsp.buf.signature_help, { buffer = bufnr })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
  end,
})

vim.cmd.colorscheme("tokyonight-storm")
