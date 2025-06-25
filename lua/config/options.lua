-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
local function setup_clipboard()
  local in_container = os.getenv("CONTAINER")
    or os.getenv("DOCKER_CONTAINER")
    or vim.fn.filereadable("/.dockerenv") == 1
  if in_container and vim.env.TMUX then
    vim.g.clipboard = {
      name = "OSC 52 + tmux",
      copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
      },
      paste = {
        ["+"] = { "tmux", "save-buffer", "-" },
        ["*"] = { "tmux", "save-buffer", "-" },
      },
    }
  elseif in_container then
    -- OSC52 copy-only if no tmux
    vim.g.clipboard = {
      name = "OSC 52 (copy only)",
      copy = {
        ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
        ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
      },
      paste = {
        ["+"] = function()
          return {}
        end,
        ["*"] = function()
          return {}
        end,
      },
    }
  else
    vim.opt.clipboard = "unnamedplus"
  end
end

setup_clipboard()
