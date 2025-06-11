return {
  "CopilotC-Nvim/CopilotChat.nvim",
  opts = {
    debug = false,
    --    model = "copilot:gpt-4",
    model = "gpt-4",
    window = {
      layout = "float", -- options: float | split | vertical
      border = "rounded",
      width = 0.5,
      height = 0.7,
    },
    prompts = {
      Explain = "Please explain this code",
      Review = "Please review this code",
    },
    selection = function(source)
      local select = require("CopilotChat.select")
      -- Prioritize visual selection, fallback to buffer if no visual selection
      return select.visual(source) or select.buffer(source)
    end,
  },
  dependencies = {
    "zbirenbaum/copilot.lua",
  },
  cmd = { "CopilotChat", "CopilotChatToggle" },
}
