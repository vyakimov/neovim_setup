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
      auto_approve = true, -- Set to true to skip confirmations
      shutdown_delay = 5000, -- 5 seconds delay before shutdown (in milliseconds)
      mcp_request_timeout = 30000, -- 30 seconds timeout for MCP requests (in milliseconds)
    })
  end,
}
