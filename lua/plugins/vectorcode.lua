return {
  "Davidyz/VectorCode",
  ft = { "python", "lua", "javascript", "typescript", "rust", "go" }, -- Add your languages
  opts = {
    -- Optional: configure async backend
    async_backend = "lsp", -- or "subprocess"
  },
  config = function(_, opts)
    require("vectorcode").setup(opts)
  end,
}
