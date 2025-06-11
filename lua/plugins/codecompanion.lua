-- ~/.config/nvim/lua/plugins/codecompanion.lua
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp", -- Optional: for completion
    "nvim-telescope/telescope.nvim", -- Optional: for history
    "stevearc/dressing.nvim", -- Optional: for input dialogs
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "openai", -- or "openai", "ollama", "copilot"
        },
        inline = {
          adapter = "openai",
        },
        agent = {
          adapter = "openai",
        },
      },
      adapters = {
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = {
              api_key = vim.env.ANTHROPIC_API_KEY,
            },
            schema = {
              model = {
                default = "claude-opus-4-20250514",
                choices = {
                  "claude-opus-4-20250514",
                  "claude-3-5-sonnet-20241022",
                  "claude-3-5-haiku-20241022",
                  "claude-3-opus-20240229",
                },
              },
              max_tokens = {
                default = 4096,
              },
              temperature = {
                default = 0.1,
              },
            },
          })
        end,
        openai = function()
          return require("codecompanion.adapters").extend("openai", {
            env = {
              api_key = vim.env.OPENAI_API_KEY,
            },
            schema = {
              model = {
                default = "gpt-4.1-mini",
                choices = {
                  "o3",
                  "o4-mini",
                  "gpt-4.1",
                  "gpt-4.1-mini",
                },
              },
            },
          })
        end,
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = "codellama:34b",
                choices = {
                  "codellama:34b",
                  "deepseek-coder:33b",
                  "llama3.1:70b",
                  "mistral:7b",
                },
              },
            },
          })
        end,
      },

      -- Data Science specific prompts
      prompts = {
        ["Data Analysis"] = {
          strategy = "chat",
          description = "Analyze data and provide insights",
          opts = {
            index = 1,
            default_prompt = true,
            mapping = "<leader>cda",
            modes = { "v" },
            slash_cmd = "analyze",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = function()
                return "You are an expert data scientist. Analyze the provided code/data and:\n"
                  .. "1. Explain what the code does\n"
                  .. "2. Identify potential issues or improvements\n"
                  .. "3. Suggest optimizations for performance\n"
                  .. "4. Recommend best practices\n"
                  .. "5. Point out any statistical or methodological concerns\n\n"
                  .. "Focus on pandas, numpy, matplotlib, seaborn, and scikit-learn best practices."
              end,
            },
            {
              role = "user",
              content = function(context)
                local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                return "Please analyze this data science code:\n\n```python\n" .. text .. "\n```"
              end,
            },
          },
        },
      },

      -- Display options
      display = {
        action_palette = {
          width = 95,
          height = 10,
        },
        chat = {
          window = {
            layout = "float", -- or "horizontal", "float"
            width = 0.45,
            height = 0.35,
            relative = "editor",
            border = "single",
            title = "CodeCompanion",
          },
          show_settings = true,
        },
      },

      -- Logging for debugging
      log_level = "ERROR", -- or "DEBUG" for troubleshooting

      -- Send code context automatically
      send_code = true,
      use_default_actions = true,
    })
  end,
}
