return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Git: Diff view" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Git: File history" },
    { "<leader>gD", "<cmd>DiffviewClose<cr>", desc = "Git: Close diff view" },
  },
  opts = {},
}
