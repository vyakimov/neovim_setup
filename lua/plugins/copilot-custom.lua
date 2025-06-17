return {
  "zbirenbaum/copilot.lua",
  -- cmd = "Copilot", -- Uncomment this if you want to lazy-load on command
  -- event = "InsertEnter", -- Or uncomment this to lazy-load on entering insert mode
  opts = {
    suggestion = {
      -- The key is that auto_trigger is true
      auto_trigger = true,
      -- Debounce can be adjusted to your liking
      debounce = 75,
      keymap = {
        -- IMPORTANT: The default keymaps are unset here
        -- We will be defining our own keymaps outside of the plugin config
        accept = "<nop>",
        accept_word = "<nop>",
        accept_line = "<nop>",
        next = "<nop>",
        prev = "<nop>",
        dismiss = "<nop>",
      },
    },
    panel = {
      -- Panel is used to show multiple suggestions
      enabled = true,
      keymap = {
        jump_prev = "[[",
        jump_next = "]]",
        accept = "<CR>",
        refresh = "gr",
        open = "<M-CR>",
      },
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

    -- This is the core part of the VS Code-like experience
    -- It uses a smart function to check if a Copilot suggestion is available
    -- and accepts it. If not, it falls back to the original Tab behavior.
    local function smart_tab()
      local copilot = require("copilot.suggestion")
      if copilot.is_visible() then
        -- If a suggestion is visible, accept it
        copilot.accept()
      else
        -- Otherwise, send a regular Tab keystroke
        -- This allows Tab to work for snippets and completion menus
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", false)
      end
    end

    -- Map the smart_tab function to the Tab key in insert mode
    vim.keymap.set("i", "<Tab>", smart_tab, {
      desc = "Copilot: Smart Accept / Fallback to Tab",
      noremap = true,
    })

    -- Other VS Code-like keymaps
    -- Accept word-by-word (Alt + ->)
    vim.keymap.set("i", "<M-Right>", function()
      require("copilot.suggestion").accept_word()
    end, { desc = "Copilot: Accept Word" })
    -- Accept line-by-line (Alt + Enter)
    vim.keymap.set("i", "<M-CR>", function()
      require("copilot.suggestion").accept_line()
    end, { desc = "Copilot: Accept Line" })

    -- Cycle through suggestions (Alt + ] and Alt + [)
    vim.keymap.set("i", "<M-]>", function()
      require("copilot.suggestion").next()
    end, { desc = "Copilot: Next Suggestion" })
    vim.keymap.set("i", "<M-[>", function()
      require("copilot.suggestion").prev()
    end, { desc = "Copilot: Previous Suggestion" })

    -- Dismiss suggestion (similar to VS Code's Esc, but more explicit)
    vim.keymap.set("i", "<C-]>", function()
      require("copilot.suggestion").dismiss()
    end, { desc = "Copilot: Dismiss Suggestion" })
  end,
}
