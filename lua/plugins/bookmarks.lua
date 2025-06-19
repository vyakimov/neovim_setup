return {
  "LintaoAmons/bookmarks.nvim",
  dependencies = {
    "kkharji/sqlite.lua",
    "nvim-telescope/telescope.nvim",
    "stevearc/dressing.nvim", -- optional: better UI
  },
  config = function()
    require("bookmarks").setup({
      -- Uses SQLite for persistence
      -- Check their default-config.lua for all options
    })
    require("telescope").load_extension("bookmarks")
  end,
  keys = {
    { "<leader>mm", "<cmd>BookmarksMark<cr>", desc = "Mark current line" },
    { "<leader>mo", "<cmd>BookmarksGoto<cr>", desc = "Go to bookmark" },
    { "<leader>ma", "<cmd>BookmarksCommands<cr>", desc = "All bookmark commands" },
    { "<leader>mg", "<cmd>BookmarksGotoRecent<cr>", desc = "Goto recent" },
  },
}
