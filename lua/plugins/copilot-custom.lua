return {
  "zbirenbaum/copilot.lua",

  -- event = "InsertEnter",   -- uncomment to lazy-load
  -- cmd   = "Copilot",       -- or lazy-load on command

  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 75,
      keymap = {
        accept = "<nop>",
        accept_word = "<nop>",
        accept_line = "<nop>",
        next = "<nop>",
        prev = "<nop>",
        dismiss = "<nop>",
      },
    },
    panel = {
      enabled = true,
      keymap = { jump_prev = "[[", jump_next = "]]", accept = "<CR>", refresh = "gr", open = "<M-CR>" },
    },
    filetypes = {
      yaml = true,
      markdown = true,
      help = false,
      gitcommit = true,
      gitrebase = true,
      hgcommit = true,
      svn = true,
      python = true,
      cvs = true,
      ["."] = true,
    },
  },

  config = function(_, opts)
    require("copilot").setup(opts)
    local sug = require("copilot.suggestion")

    -- Tab: accept suggestion or fall back to a literal <Tab>.
    vim.keymap.set("i", "<Tab>", function()
      if sug.is_visible() then
        sug.accept()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
      end
    end, { desc = "Copilot · accept / Tab" })

    -- New line then immediately ask Copilot → multi-line suggestions.
    vim.keymap.set("i", "<CR>", function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
      vim.defer_fn(sug.next, 10)
    end, { desc = "Copilot · newline & trigger" })

    -- Manual trigger (choose a key that macOS does not intercept).
    vim.keymap.set("i", "<C-\\>", sug.next, { desc = "Copilot · trigger" })

    -- Extra helpers.
    vim.keymap.set("i", "<M-Right>", sug.accept_word, { desc = "Copilot · accept word" })
    vim.keymap.set("i", "<M-CR>", sug.accept_line, { desc = "Copilot · accept line" })
    vim.keymap.set("i", "<M-]>", sug.next, { desc = "Copilot · next" })
    vim.keymap.set("i", "<M-[>", sug.prev, { desc = "Copilot · previous" })
    vim.keymap.set("i", "<C-]>", sug.dismiss, { desc = "Copilot · dismiss" })
  end,
}
