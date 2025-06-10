return {
  "CopilotC-Nvim/CopilotChat.nvim",
  opts = {
    -- your custom options here
    debug = false,
    window = {
      layout = "float", -- options: float | split | vertical
      border = "rounded",
      width = 0.5,
      height = 0.7,
    },
    prompts = {
      Explain = "Please explain this code",
      Review = "Please review this code",
      -- Add more custom commands here
    },
  },
  dependencies = {
    "zbirenbaum/copilot.lua", -- make sure Copilot itself is installed
  },
  cmd = { "CopilotChat", "CopilotChatToggle" },
  keys = {
    { "<leader>cd", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat" },
  },
}
