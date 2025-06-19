return {
  "nvim-telescope/telescope.nvim",
  keys = {
    -- Add buffer-specific search
    { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer fuzzy search" },
    { "<leader>st", "<cmd>Telescope treesitter<cr>", desc = "Treesitter symbols" },
  },
}
