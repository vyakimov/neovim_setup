-- ~/.config/nvim/lua/plugins/codecompanion.lua
return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp", -- Optional: for completion
    "nvim-telescope/telescope.nvim", -- Optional: for history
    "stevearc/dressing.nvim", -- Optional: for input dialogs
    "MeanderingProgrammer/render-markdown.nvim", -- For better markdown rendering
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "anthropic", -- Use Claude models to mimic Claude Code
        },
        inline = {
          adapter = "anthropic",
        },
        agent = {
          adapter = "anthropic",
        },
      },
      prompt_library = {
        ["Claude Code Assistant"] = {
          strategy = "chat",
          description = "Claude Code-style assistant for software engineering tasks",
          opts = {
            modes = { "n", "v" },
            auto_submit = false,
          },
          prompts = {
            {
              role = "system",
              content = [[You are Claude Code, an AI coding assistant that helps with software engineering tasks. Your responses should be concise, direct, and to the point.

Key behaviors:
- Be concise with fewer than 4 lines unless asked for detail
- Minimize output tokens while maintaining helpfulness and accuracy
- Answer questions directly without unnecessary preamble or postamble
- Focus on the specific query at hand
- Use tools proactively when needed (file operations, searches, etc.)
- Follow existing code conventions and patterns
- Never assume libraries are available - check first
- Always follow security best practices

When working with code:
- Read files before editing to understand context
- Prefer editing existing files over creating new ones
- Use existing libraries and utilities in the codebase
- Follow the project's code style and conventions
- Make changes incrementally and verify they work

For file operations:
- Use absolute paths
- Check directory structure before creating files
- Understand the codebase architecture before making changes

Be helpful but concise. One word answers are best when appropriate.]],
            },
            {
              role = "user",
              content = "",
              opts = { contains_code = true },
            },
          },
        },
        ["Code Review"] = {
          strategy = "chat",
          description = "Review code for best practices and improvements",
          opts = {
            modes = { "n", "v" },
            auto_submit = false,
          },
          prompts = {
            {
              role = "system",
              content = [[Review the provided code for:
- Code quality and best practices
- Security vulnerabilities
- Performance improvements
- Maintainability issues
- Documentation needs

Provide specific, actionable feedback.]],
            },
            {
              role = "user",
              content = "",
              opts = { contains_code = true },
            },
          },
        },
        ["Explain Code"] = {
          strategy = "chat", 
          description = "Explain selected code in detail",
          opts = {
            modes = { "v" },
            auto_submit = false, -- Changed to false for consistency
          },
          prompts = {
            {
              role = "system",
              content = "Explain the selected code clearly and concisely, focusing on what it does and how it works.",
            },
            {
              role = "user",
              content = "",
              opts = { contains_code = true },
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
                default = "claude-3-5-sonnet-20241022", -- Use Sonnet as default for better performance
                choices = {
                  "claude-3-5-sonnet-20241022",
                  "claude-3-5-haiku-20241022", 
                  "claude-3-opus-20240229",
                },
              },
              max_tokens = {
                default = 8192, -- Reasonable default for code tasks
              },
              temperature = {
                default = 0.1, -- Low temperature for consistent code generation
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
          -- Add VectorCode integration
          vectorcode = {
            name = "vectorcode",
            description = "Search and analyze code using semantic search",
            opts = {
              enabled = function()
                return vim.fn.executable("vectorcode") == 1
              end,
            },
          },
          -- Add MCP Hub integration placeholder
          mcp_hub = {
            name = "mcp_hub", 
            description = "Connect to MCP Hub for extended tool capabilities",
            opts = {
              enabled = function()
                -- Check if MCP Hub is available
                return vim.env.MCP_HUB_URL ~= nil
              end,
            },
          },
        },
      },

      -- Display options - Make it more like Claude Code
      display = {
        action_palette = {
          width = 120, -- Wider for better visibility
          height = 15,  -- Taller for more options
          prompt = "Claude Code ",
          provider = "telescope",
          opts = {
            show_default_actions = true,
            show_default_prompt_library = true,
          },
        },
        chat = {
          window = {
            layout = "horizontal", -- Better for code work
            width = 0.6,
            height = 0.6,
            relative = "editor", 
            border = "rounded", -- More modern look
            title = "Claude Code Assistant",
          },
          show_settings = true, -- Allow model switching
          show_token_count = true, -- Monitor usage
          welcome_message = "Hello! I'm your Claude Code assistant. How can I help you with your code today?",
        },
        diff = {
          provider = "mini_diff", -- Better diff visualization
        },
      },

      -- Enhanced for Claude Code-like behavior
      log_level = "INFO", -- More verbose for debugging
      send_code = true, -- Always include code context
      use_default_actions = true,
      
      -- Disable auto-submit for review-first workflow like Claude Code
      auto_submit = false,

      -- Enable file operations like Claude Code
      file_operations = {
        enabled = true,
        auto_save = false, -- Don't auto-save, let user review first
      },
    })
  end,
}
