return {
  "mason-org/mason.nvim",
  opts = {
    ensure_installed = {
      -- Formatters
      "black", -- Python formatter
      "prettierd", -- Formatter for multiple web languages (JS, JSON, CSS, etc.)
      "shfmt", -- Shell script formatter
      "stylua", -- Lua formatter

      -- Language Servers (LSPs)
      "docker-compose-language-service", -- Docker Compose LSP
      "dockerfile-language-server", -- Dockerfile LSP
      "json-lsp", -- JSON LSP
      "lua-language-server", -- Lua LSP
      "r-languageserver", -- R language LSP
      "pyright", -- Python LSP
      "taplo", -- TOML LSP
      "yaml-language-server", -- YAML LSP

      -- Linters
      "hadolint", -- Dockerfile linter
      "markdownlint-cli2", -- Markdown linter
      "marksman", -- Markdown LSP/linter (primarily for Markdown)
      "mypy", -- Python type checker (can be used as linter)
      "ruff", -- Python linter/formatter
      "shellcheck", -- Shell script linter
    },
  },
}
