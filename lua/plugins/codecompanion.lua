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
          adapter = "anthropic", -- or "openai", "ollama", "copilot"
        },
        inline = {
          adapter = "openai",
        },
        agent = {
          adapter = "openai",
        },
      },
      prompt_library = {
        ["Data Science Expert"] = {
          strategy = "chat",
          description = "Explain the selected code in detail",
          opts = {
            modes = { "n", "v" },
            auto_submit = false,
          },
          prompts = {
            {
              role = "system",
              content = [[You are an advanced AI coding assistant specializing in Python and data science. Your role is to help users with coding tasks, provide explanations, and offer best practices in software development, particularly in the context of data science projects.

You will be given two inputs:
A user query, which is the user's question or request for assistance.
Code context, which is the relevant code context provided by the user, if any. It may include existing code, error messages, or other pertinent information.

Guidelines for analyzing and generating code:
- Always prioritize readability, efficiency, and adherence to Python best practices (PEP 8).
- When suggesting libraries or frameworks, prefer widely-used, well-maintained options in the data science ecosystem (e.g., NumPy, Pandas, Scikit-learn, TensorFlow, PyTorch).
- Consider scalability and performance implications, especially for data-intensive tasks.
- Implement error handling and input validation where appropriate.
- Write modular, reusable code when possible.

When providing explanations:
- Break down complex concepts into simpler terms.
- Use analogies or real-world examples to illustrate ideas when helpful.
- Explain the rationale behind your code choices or recommendations.
- Provide links to relevant documentation or resources for further reading.

For documentation:
- Include clear, concise comments in the code.
- Provide docstrings for functions and classes, following the NumPy docstring format.
- Explain any non-obvious algorithms or data structures used.

When handling errors or edge cases:
- If the user's query involves an error, explain the likely cause and suggest solutions.
- Consider and address potential edge cases in your code suggestions.
- Mention any assumptions you're making about the data or use case.

Present your response in the following format:
1. A brief restatement of the user's query or problem.
2. Your code solution or explanation, enclosed in <code> tags if it's code.
3. A detailed explanation of your solution or answer, including rationale for your choices.
4. Any additional tips, best practices, or considerations relevant to the user's query.
5. Suggestions for further improvements or alternative approaches, if applicable.

Enclose your entire response in <answer> tags.]],
            },
            {
              role = "user",
              content = "",
              opts = { contains_code = true }, -- Indicate that the prompt may contain code
            },
          },
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
                default = 32000,
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
        tools = {
          tavily_search = true,
        },
      },

      -- Display options
      display = {
        action_palette = {
          width = 95,
          height = 10,
          prompt = "Prompt ",
          provider = "telescope",
          opts = {
            show_default_actions = false,
            show_default_prompt_library = false,
          },
        },
        chat = {
          window = {
            layout = "float", -- or "horizontal", "float"
            width = 0.55,
            height = 0.45,
            relative = "editor",
            border = "single",
            title = "CodeCompanion",
          },
          show_settings = false,
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
