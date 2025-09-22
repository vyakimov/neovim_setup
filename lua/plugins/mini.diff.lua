return {
  "nvim-mini/mini.diff",
  lazy = true,
  enabled = true,
  version = false,
  event = "VeryLazy",
  keys = {
    {
      "<leader>go",
      function()
        require("mini.diff").toggle_overlay(0)
      end,
      desc = "Toggle mini.diff overlay",
    },
  },
  opts = {
    view = {
      style = "sign",
      signs = {
        add = "▎",
        change = "▎",
        delete = "契",
      },
    },
    mappings = {
      -- Apply hunks inside a visual/operator region
      apply = "gh",
      -- Reset hunks inside a visual/operator region
      reset = "gH",
      -- Hunk range textobject to be used inside operator
      -- Works also in Visual mode if mapping differs from apply and reset
      textobject = "gh",
      -- Go to hunk range in given direction
      goto_first = "[H",
      goto_prev = "[h",
      goto_next = "]h",
      goto_last = "]H",
    },
  },
}
