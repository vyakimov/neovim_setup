local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts) -- Deep extend if opts contains nested tables
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- 1. Cmd-Left Arrow (Beginning of Line)
-- Alacritty sends <C-A>
map({ "n", "v" }, "<C-A>", "0", { desc = "Go to beginning of line (col 0)" }) -- Use '0' for true beginning
map("i", "<C-A>", "<Home>", { desc = "Go to beginning of line" }) -- <Home> is natural in insert mode

-- 2. Cmd-Right Arrow (End of Line)
-- Alacritty sends <C-E>
map({ "n", "v" }, "<C-E>", "$", { desc = "Go to end of line" })
map("i", "<C-E>", "<End>", { desc = "Go to end of line" }) -- <End> is natural in insert mode

-- 3. Option-Left Arrow (Move word left)
-- Assuming Alacritty sends ESC b, which Neovim sees as <M-b>
map("n", "<M-Left>", "b", { desc = "Move word left" })
map("i", "<M-Left>", "<C-O>b", { desc = "Move word left" }) -- <C-O> executes one normal mode command

-- 4. Option-Right Arrow (Move word right)
-- Assuming Alacritty sends ESC f, which Neovim sees as <M-f>
map("n", "<M-Right>", "w", { desc = "Move word right" })
map("i", "<M-Right>", "<C-O>w", { desc = "Move word right" })

-- 5. Option-Backspace (Delete word backward)
-- Assuming Alacritty sends ESC Backspace (<M-BS>) or ESC DEL (<M-Del>)
-- If Alacritty is set to send <C-W> directly for Option-Backspace,
-- then the INSERT MODE mapping below is not strictly necessary but doesn't hurt.
map("n", "<M-BS>", "db", { desc = "Delete word backward" })
map("n", "<M-Del>", "db", { desc = "Delete word backward" }) -- Some terminals send DEL

map("i", "<M-BS>", "<C-W>", { desc = "Delete word backward" })
map("i", "<M-Del>", "<C-W>", { desc = "Delete word backward" })

map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })

-- You might also want to map for other Alt/Option combinations if needed
-- For example, some systems use <M-Left> / <M-Right> for word movement
-- These are typically if your terminal sends xterm-style Alt+Arrow sequences like "\e[1;3D"
-- map("i", "<M-Left>", "<C-O>b")
-- map("n", "<M-Left>", "b")
-- map("i", "<M-Right>", "<C-O>w")
-- map("n", "<M-Right>", "w")
