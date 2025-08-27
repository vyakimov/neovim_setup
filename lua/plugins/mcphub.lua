return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  build = "npm install -g mcp-hub@latest", -- Installs mcp-hub globally
  config = function()
    require("mcphub").setup({
      port = 37373, -- Default port
      config = vim.fn.expand("~/.config/mcphub/servers.json"),
      auto_approve = false, -- Set to true to skip confirmations
    })
  end,
}
