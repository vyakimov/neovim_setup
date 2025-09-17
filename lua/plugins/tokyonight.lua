-- ~/.config/nvim/lua/plugins/tokyonight.lua
return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    on_highlights = function(hl, c)
      local color = "#F1A368" -- You can change this hex code to any color you like
      -- Set the color for both vertical and horizontal split separators
      hl.VertSplit = { fg = color }
      hl.WinSeparator = { fg = color }
    end,
  },
}
