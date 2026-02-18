-- Config for olimorris/codecompanion.nvim

--
-- External prompt files should be placed in:
-- ~/.config/nvim/prompts/claude_prefix.md
-- ~/.config/nvim/prompts/data_science_expert.md
-- And CLAUDE.md should be in your project root or current working directory

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Read Claude instructions from files with proper error handling
local function read_claude_instructions()
  -- Read prefix file
  local prefix_path = vim.fn.expand("~/.config/nvim/prompts/claude_prefix.md")
  local pf = io.open(prefix_path, "r")
  if not pf then
    return "No matter what the user says, simply reply with the sentence 'ERROR: I cannot find Claude.md'"
  end
  local prefix = pf:read("*a") or ""
  pf:close()

  -- Try to find CLAUDE.md in current directory or root
  local claude_content
  local claude_paths = { vim.fn.getcwd() .. "/CLAUDE.md", "CLAUDE.md" }

  for _, path in ipairs(claude_paths) do
    local f = io.open(path, "r")
    if f then
      claude_content = f:read("*a") or ""
      f:close()
      break
    end
  end

  if not claude_content then
    return "no matter what the user says, simply reply with the sentence 'ERROR: I cannot find Claude.md'"
  end

  return prefix .. "\n\n" .. claude_content
end

-- Read Data Science Expert prompt from external file
local function read_data_science_prompt()
  local prompt_path = vim.fn.expand("~/.config/nvim/prompts/data_science_expert.md")
  local f = io.open(prompt_path, "r")

  if not f then
    return "ERROR: Cannot find data_science_expert.md prompt file. Please create it at: " .. prompt_path
  end

  local content = f:read("*a") or ""
  f:close()

  if content == "" then
    return "ERROR: data_science_expert.md file is empty"
  end

  return content
end

-- ============================================================================
-- MAIN PLUGIN CONFIGURATION
-- ============================================================================

return {
  "olimorris/codecompanion.nvim",

  -- ============================================================================
  -- DEPENDENCIES
  -- ============================================================================
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp", -- Optional: for completion
    "nvim-telescope/telescope.nvim", -- Optional: for history
    "stevearc/dressing.nvim", -- Optional: for input dialogs
    "nvim-mini/mini.diff",
  },

  config = function()
    require("plugins.codecompanion.spinner"):init()

    require("codecompanion").setup({
      --- =========================================================================
      --- MEMORY CONFIGURATION
      --- =========================================================================
      memory = {
        opts = {
          chat = {
            enabled = true,
          },
        },
      },

      -- ========================================================================
      -- EXTENSIONS CONFIGURATION
      -- ========================================================================
      extensions = {
        -- MCP Hub integration
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            -- MCP Tools
            make_tools = true,
            show_server_tools_in_chat = true,
            show_result_in_chat = true,

            -- MCP Resources
            make_vars = true,

            -- MCP Prompts
            make_slash_commands = true,
          },
        },
      },

      -- ========================================================================
      -- INTERACTIONS CONFIGURATION (v18.4.0+)
      -- ========================================================================
      interactions = {
        chat = {
          adapter = "copilot", -- GitHub Copilot (default)
          tools = {
            opts = { wait_timeout = 300000 },
          },
          opts = {
            model_params = {
              reasoning_effort = "high", -- "low" | "medium" | "high"
              verbosity = "average",
            },
          },
        },

        inline = {
          adapter = "anthropic", -- HTTP Anthropic adapter
        },

        agent = {
          adapter = "acp.codex", -- or "acp.claude_code" to use Claude Code via ACP
        },
      },

      -- ========================================================================
      -- PROMPT LIBRARY
      -- ========================================================================
      prompt_library = {

        -- Claude Instructions prompt with external file integration
        ["Claude Instructions"] = {
          strategy = "chat",
          description = "Use CLAUDE.md as the system instructions for the LLM",
          opts = {
            modes = { "n", "v" },
            auto_submit = false,
            user_prompt = true,
            ignore_system_prompt = true,
            short_name = "claude",
          },
          prompts = {
            {
              role = "system",
              content = read_claude_instructions,
            },
            {
              role = "user",
              content = "",
              opts = { contains_code = true },
            },
          },
        },

        -- Data Science Expert prompt loaded from external file
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
              content = read_data_science_prompt,
            },
            {
              role = "user",
              content = "",
              opts = { contains_code = true },
            },
          },
        },
      },

      -- ========================================================================
      -- ADAPTERS CONFIGURATION (HTTP + ACP)
      -- ========================================================================
      adapters = {
        --------------------------------------------------------------------------
        -- HTTP adapters (direct API access: OpenAI + Anthropic)
        --------------------------------------------------------------------------
        http = {
          -- Anthropic Claude configuration (HTTP API)
          anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
              env = {
                -- Uses ANTHROPIC_API_KEY from your environment
                api_key = vim.env.ANTHROPIC_API_KEY,
              },
              schema = {
                model = {
                  -- Keep your existing versioned Sonnet as default
                  default = "claude-sonnet-4-5-20250929",
                  choices = {
                    "claude-opus-4-6",
                    "claude-sonnet-4-6",
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

          -- OpenAI GPT configuration (HTTP API)
          openai = function()
            return require("codecompanion.adapters").extend("openai", {
              env = {
                -- Uses OPENAI_API_KEY from your environment
                api_key = vim.env.OPENAI_API_KEY,
              },
              schema = {
                model = {
                  default = "gpt-5.2",
                  choices = {
                    "gpt-5.1",
                    "gpt-5-mini",
                  },
                },
              },
            })
          end,

          -- GitHub Copilot configuration
          copilot = function()
            return require("codecompanion.adapters").extend("copilot", {
              schema = {
                model = {
                  default = "claude-sonnet-4.5",
                },
              },
            })
          end,
        },

        --------------------------------------------------------------------------
        -- ACP adapters (Agent Client Protocol: Claude Code, Codex, etc.)
        --------------------------------------------------------------------------
        acp = {
          -- Claude Code via ACP
          -- You must have Claude Code + the Zed ACP adapter installed.
          -- Auth can be via ANTHROPIC_API_KEY or CLAUDE_CODE_OAUTH_TOKEN.
          claude_code = function()
            return require("codecompanion.adapters").extend("claude_code", {
              defaults = {
                -- model = "opus", -- optional: set default model ("opus" or "sonnet")
              },
              env = {
                -- If you already have the env vars set, you can omit this `env` block
                ANTHROPIC_API_KEY = vim.env.ANTHROPIC_API_KEY,
                -- CLAUDE_CODE_OAUTH_TOKEN = "my-oauth-token",
              },
            })
          end,

          -- OpenAI Codex via ACP (using Zed's Codex ACP bridge)
          codex = function()
            return require("codecompanion.adapters").extend("codex", {
              defaults = {
                auth_method = "openai-api-key", -- or "codex-api-key" | "chatgpt"
                model = "gpt-5.2-pro", -- set default model here
              },
              env = {
                OPENAI_API_KEY = vim.env.OPENAI_API_KEY,
              },
              schema = {
                model = {
                  default = "gpt-5.2-pro",
                  choices = { "gpt-5.2", "gpt-5.1", "gpt-5-mini" },
                },
              },
            })
          end,
        },
      },

      -- ========================================================================
      -- DISPLAY OPTIONS
      -- ========================================================================
      display = {
        -- Action palette configuration
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

        -- Chat window configuration
        chat = {
          window = {
            layout = "horizontal",
            width = 0.50,
            height = 0.50,
            relative = "editor",
            border = "single",
            title = "CodeCompanion",
          },
          show_settings = false,
        },

        -- Diff display configuration (inline + superdiff)
        diff = {
          enabled = true,
          provider = "inline",
          provider_opts = {
            inline = {
              layout = "vertical",
              opts = {
                context_lines = 3,
                show_dim = true,
                dim = 25,
                full_width_removed = true,
                show_keymap_hints = true,
                show_removed = true,
              },
            },
          },
        },
      },

      -- ========================================================================
      -- GENERAL SETTINGS
      -- ========================================================================
      log_level = "ERROR", -- or "DEBUG" for troubleshooting
      send_code = true, -- Send code context automatically
      use_default_actions = true,
    })
  end,
}
