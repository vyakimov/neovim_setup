return {
  -- REPL Provider: iron.nvim
  {
    "hkupty/iron.nvim",
    -- No specific key for lazy loading here, as NotebookNavigator might trigger it.
    -- You can add `event = "VeryLazy"` if you prefer to delay loading until explicitly used.
    config = function()
      local iron = require("iron.core")
      local iron_fts_common = require("iron.fts.common")
      iron.setup({
        config = {
          -- Preferred REPL for Python.
          -- Ensure 'ipython' is in your PATH or provide the full path.
          repl_definition = {
            python = {
              command = { "ipython" },
              format = iron_fts_common.bracketed_paste,
            },
            r = {
              command = { "radian" }, -- { "R", "--quiet", "--no-save", "--no-restore" }, -- Or just {"R"} or {"radian"} if you use radian
              format = iron_fts_common.bracketed_paste, -- Use bracketed paste for R
            },
          },
          preferred = "ipython",
          -- How the REPL window will be displayed.
          -- Other options: require('iron.view').bottom(40), require('iron.view').top(40), require('iron.view').float(), etc.
          repl_open_cmd = require("iron.view").split.vertical(0.4), -- Opens in a vertical split taking 40% of width
          -- Automatically close the REPL buffer when the REPL process ends
          scratch_repl = true,
        },
        -- Keymaps for direct iron.nvim usage (optional if primarily using NotebookNavigator)
        -- These allow sending code directly without necessarily defining a cell.
        keymaps = {
          send_motion = "<leader>rs", -- Send code defined by a motion
          --          visual_send = "<leader>rv", -- Send visually selected code
          visual_send = "", -- Send visually selected code
          send_file = "<leader>rf", -- Send the entire file
          --          send_line = "<leader>rl", -- Send the current line
          send_line = "", -- Send the current line
          cr = "<leader>r<CR>", -- Send a carriage return to the REPL
          interrupt = "<leader>ri", -- Send interrupt signal (Ctrl-C)
          exit = "<leader>rq", -- Exit the REPL
          clear = "<leader>rc", -- Clear REPL screen (if supported by REPL)
        },
        -- Highlighting for the REPL window (requires nvim-treesitter)
        highlight = {
          italic = true,
        },
      })
      vim.keymap.set("n", "<leader>fr", function()
        local current_buf = vim.api.nvim_get_current_buf()
        local buf_name = vim.api.nvim_buf_get_name(current_buf)
        local current_ft = vim.bo.filetype

        -- Check if we're currently in a REPL buffer
        if string.match(buf_name, "iron://") or current_ft == "iron" then
          -- We're in REPL, switch to previous window
          vim.cmd("wincmd p")
        else
          -- We're in editor, try to focus or create REPL
          local repl_exists = false

          -- Check if there's an active REPL window
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local win_buf = vim.api.nvim_win_get_buf(win)
            local win_buf_name = vim.api.nvim_buf_get_name(win_buf)
            local win_ft = vim.bo[win_buf].filetype

            if string.match(win_buf_name, "iron://") or win_ft == "iron" then
              -- Found REPL window, focus it
              vim.api.nvim_set_current_win(win)
              repl_exists = true
              break
            end
          end

          if not repl_exists then
            -- No REPL found, create one
            iron.repl_for(current_ft)
            -- After creating, find and focus the new REPL window
            vim.defer_fn(function()
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local win_buf = vim.api.nvim_win_get_buf(win)
                local win_buf_name = vim.api.nvim_buf_get_name(win_buf)
                local win_ft = vim.bo[win_buf].filetype

                if string.match(win_buf_name, "iron://") or win_ft == "iron" then
                  vim.api.nvim_set_current_win(win)
                  break
                end
              end
            end, 100) -- Small delay to ensure REPL is created
          end
        end
      end, { desc = "Iron: Toggle REPL Focus" })
      vim.keymap.set("t", "jk", "<C-\\><C-n>", { desc = "Exit terminal insert mode with jk" })
    end,
  },

  -- Cell Navigation and Execution: NotebookNavigator.nvim
  {
    "GCBallesteros/NotebookNavigator.nvim",
    dependencies = {
      "hkupty/iron.nvim", -- Explicitly list iron.nvim as a dependency
      "nvim-lua/plenary.nvim", -- Often a dependency for complex plugins
      "nvim-mini/mini.hipatterns", -- For cell highlighting (recommended)
      -- "nvim-mini/mini.ai",       -- Optional: if you want cell-based textobjects via mini.ai
    },
    opts = { -- Using `opts` is a clean way to pass configuration to the plugin's `setup` function with lazy.nvim
      -- Default cell_markers = { python = "# %%" } is what we want.
      -- You can customize markers for other languages if needed.
      -- Ensure the REPL provider is correctly inferred or specified.
      -- By default, it should pick up iron.nvim if it's available.
      -- repl_provider = "iron.nvim", -- Usually not needed to specify if iron is the only one

      -- Optional: if you want cell highlighting using NotebookNavigator's built-in syntax
      -- (mini.hipatterns is generally preferred for more advanced highlighting)
      -- syntax_highlight = true,
    },
    -- Keymaps are crucial for interacting with NotebookNavigator.
    -- It's good practice to define them within the plugin spec or your global keymap file.
    keys = {
      {
        "<leader>cx",
        function()
          require("notebook-navigator").run_cell()
        end,
        desc = "NN: Run Current Cell",
      },
      {
        "<leader>cn",
        function()
          require("notebook-navigator").run_and_move()
        end,
        desc = "NN: Run Cell & Move Next",
      },
      {
        "<leader>c]",
        function()
          require("notebook-navigator").add_cell_below()
        end,
        desc = "NN: Add Cell Below",
      },
      {
        "<leader>c[",
        function()
          require("notebook-navigator").add_cell_above()
        end,
        desc = "NN: Add Cell Above",
      },
      -- You can add more keymaps for other NotebookNavigator functions like swap_cell, merge_cell, etc.
    },
    config = function(_, opts) -- The second argument `opts` will contain what you defined in `opts` table above.
      require("notebook-navigator").setup(opts)
    end,
  },

  -- Optional but Recommended: Cell Highlighting with mini.hipatterns
  {
    "nvim-mini/mini.hipatterns",
    event = "BufReadPre", -- Load early enough to highlight on file open
    dependencies = { "GCBallesteros/NotebookNavigator.nvim" }, -- Ensure NotebookNavigator is available
    opts = function()
      -- Ensure NotebookNavigator is loaded before trying to access its spec
      local nn_loaded, nn = pcall(require, "notebook-navigator")
      if not nn_loaded then
        vim.notify("NotebookNavigator not found for mini.hipatterns setup", vim.log.levels.WARN)
        return {}
      end

      return {
        highlighters = {
          -- This uses NotebookNavigator's provided spec to highlight cell markers
          -- that NotebookNavigator itself recognizes.
          notebook_cells = nn.minihipatterns_spec,
        },
      }
    end,
  },
}
