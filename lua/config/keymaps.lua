local function map(mode, lhs, rhs, opts)
  local defaults = { noremap = true, silent = true }
  if opts then
    defaults = vim.tbl_extend("force", defaults, opts)
  end
  vim.keymap.set(mode, lhs, rhs, defaults)
end

local sys = '"+'

-- ──────────────────────────────────────────────
-- Movement (Cmd / Ctrl + Arrow, Option + Arrow)
-- ──────────────────────────────────────────────
-- Beginning / End of line
map({ "n", "v" }, "<C-A>", "0", { desc = "Go to beginning of line" })
map("i", "<C-A>", "<Home>", { desc = "Go to beginning of line" })
map({ "n", "v" }, "<C-E>", "$", { desc = "Go to end of line" })
map("i", "<C-E>", "<End>", { desc = "Go to end of line" })

-- Word left / right
map("n", "<M-Left>", "b", { desc = "Move word left" })
map("i", "<M-Left>", "<C-O>b", { desc = "Move word left" })
map("n", "<M-Right>", "w", { desc = "Move word right" })
map("i", "<M-Right>", "<C-O>w", { desc = "Move word right" })

-- Delete word backward
map("n", "<M-BS>", "db", { desc = "Delete word backward" })
map("n", "<M-Del>", "db", { desc = "Delete word backward" })
map("i", "<M-BS>", "<C-W>", { desc = "Delete word backward" })
map("i", "<M-Del>", "<C-W>", { desc = "Delete word backward" })

-- ──────────────────────────────────────────────
-- Clipboard (system register)
-- ──────────────────────────────────────────────
map({ "n", "v" }, "<leader>y", sys .. "y", { desc = "Yank to system clipboard" })
map({ "n", "v" }, "<leader>p", sys .. "p", { desc = "Paste from system clipboard" })
map({ "n", "v" }, "<leader>x", sys .. "x", { desc = "Cut to system clipboard" })

-- ──────────────────────────────────────────────
-- Line & change operations → system register
-- ──────────────────────────────────────────────
map("n", "<leader>dd", sys .. "dd", { desc = "Delete line → system" })
map("n", "<leader>D", sys .. "D", { desc = "Delete to EOL → system" })
map("n", "<leader>d", sys .. "d", { desc = "Delete motion → system" })
map("v", "<leader>d", sys .. "d", { desc = "Delete selection → system" })
map("n", "<leader>x", sys .. "x", { desc = "Delete char → system" })
map("n", "<leader>X", sys .. "X", { desc = "Delete char backward → system" })
map("n", "<leader>c", sys .. "c", { desc = "Change motion → system" })
map("n", "<leader>cc", sys .. "cc", { desc = "Change line → system" })
map("n", "<leader>C", sys .. "C", { desc = "Change to EOL → system" })
map("v", "<leader>c", sys .. "c", { desc = "Change selection → system" })

-- ──────────────────────────────────────────────
-- Yanky integration
-- ──────────────────────────────────────────────
map({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
map({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
map({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
map({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
map("n", "<C-p>", "<Plug>(YankyPreviousEntry)")
map("n", "<C-n>", "<Plug>(YankyNextEntry)")

-- ──────────────────────────────────────────────
-- Insert‐mode convenience
-- ──────────────────────────────────────────────
map("i", "jk", "<C-\\><C-n>", { desc = "Exit insert mode with 'jk'" })

-- ──────────────────────────────────────────────
-- CodeCompanion
-- ──────────────────────────────────────────────
map({ "n", "v" }, "<leader>cq", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion Actions" })
map("n", "<leader>cd", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "Toggle CodeCompanion Chat" })
map("v", "<leader>cd", "<cmd>CodeCompanionChat<cr>", { desc = "Send selection to Chat" })
map("v", "<leader>cD", function()
  vim.cmd("'<,'>CodeCompanionChat")
  vim.defer_fn(function()
    vim.cmd("normal! GiExplain this code step by step:")
  end, 100)
end, { desc = "Explain selection in detail" })
