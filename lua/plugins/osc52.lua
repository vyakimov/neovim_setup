return {
  "ojroques/nvim-osc52",
  event = "VeryLazy",
  config = function()
    require("osc52").setup({
      max_length = 0,
      silent = true, -- Changed to true to reduce noise
      trim = false,
    })

    local is_remote = os.getenv("SSH_CONNECTION") ~= nil or os.getenv("SSH_CLIENT") ~= nil
    local in_container = os.getenv("CONTAINER")
      or os.getenv("DOCKER_CONTAINER")
      or vim.fn.filereadable("/.dockerenv") == 1

    if is_remote or in_container then
      local function osc52_copy(register)
        return function(lines)
          -- lines is a table of strings
          local text = table.concat(lines, "\n")
          require("osc52").copy(text)
        end
      end

      if vim.env.TMUX then
        vim.g.clipboard = {
          name = "OSC 52 + tmux",
          copy = {
            ["+"] = osc52_copy("+"),
            ["*"] = osc52_copy("*"),
          },
          paste = {
            ["+"] = { "tmux", "save-buffer", "-" },
            ["*"] = { "tmux", "save-buffer", "-" },
          },
        }
      else
        vim.g.clipboard = {
          name = "OSC 52 (copy only)",
          copy = {
            ["+"] = osc52_copy("+"),
            ["*"] = osc52_copy("*"),
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
      end
    else
      vim.opt.clipboard = "unnamedplus"
    end
  end,
}
