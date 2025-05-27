-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local opts = { noremap = true, silent = true }

-- Line operations
vim.keymap.set("n", "<leader>dd", '"_dd', vim.tbl_extend("force", opts, { desc = "Delete line (no register)" }))
vim.keymap.set("n", "<leader>D", '"_D', vim.tbl_extend("force", opts, { desc = "Delete to end of line (no register)" }))

-- Motion-based delete
vim.keymap.set("n", "<leader>d", '"_d', vim.tbl_extend("force", opts, { desc = "Delete motion (no register)" }))

-- Visual mode delete
vim.keymap.set("v", "<leader>d", '"_d', vim.tbl_extend("force", opts, { desc = "Delete selection (no register)" }))

-- Character operations
vim.keymap.set("n", "<leader>x", '"_x', vim.tbl_extend("force", opts, { desc = "Delete char forward (no register)" }))
vim.keymap.set("n", "<leader>X", '"_X', vim.tbl_extend("force", opts, { desc = "Delete char backward (no register)" }))

---- Change operations (delete + insert mode)
--vim.keymap.set("n", "<leader>c", '"_c', vim.tbl_extend("force", opts, { desc = "Change motion (no register)" }))
--vim.keymap.set("n", "<leader>cc", '"_cc', vim.tbl_extend("force", opts, { desc = "Change line (no register)" }))
--vim.keymap.set("n", "<leader>C", '"_C', vim.tbl_extend("force", opts, { desc = "Change to end of line (no register)" }))
--vim.keymap.set("v", "<leader>c", '"_c', vim.tbl_extend("force", opts, { desc = "Change selection (no register)" }))

vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
