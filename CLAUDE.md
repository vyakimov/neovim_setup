# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture

This is a Neovim configuration built on LazyVim, a starter template that provides a complete IDE-like experience. The configuration follows LazyVim's structured approach:

- **Entry Point**: `init.lua` bootstraps lazy.nvim and sets up basic LSP configuration for Python (Pyright) with custom keymaps
- **Plugin Management**: Uses lazy.nvim for plugin management, with configuration split across multiple files
- **Configuration Structure**:
  - `lua/config/`: Core LazyVim configuration (lazy.lua, keymaps.lua, options.lua, autocmds.lua)
  - `lua/plugins/`: Custom plugin specifications that extend or override LazyVim defaults
  - `lua/core/`: Additional core functionality
  - `lazyvim.json`: LazyVim extras configuration defining enabled language support and features

## Key Components

### LazyVim Extras
The configuration includes specific LazyVim extras for:
- AI: GitHub Copilot and Copilot Chat
- Coding: Blink, LuaSnip, mini-comment, nvim-cmp, Yanky (clipboard management)
- Editor: Telescope (fuzzy finder)
- Languages: Docker, JSON, Markdown, Python, R, TOML, YAML
- Formatting: Black (Python)

### Custom Plugin Configurations
Notable custom plugins in `lua/plugins/`:
- `bookmarks.lua`: Bookmark management
- `codecompanion.lua`: Claude Code-style AI assistant with VectorCode and MCP Hub integration
- `copilot-custom.lua`: Custom Copilot configuration
- `telescope.lua`: Fuzzy finder customizations
- `treesitter.lua`: Syntax highlighting
- `yanky.lua`: Advanced clipboard functionality

### Key Features
- **Container Support**: Smart clipboard handling for Docker/container environments with OSC52 support
- **Custom Keymaps**: Extensive custom keybindings in `lua/config/keymaps.lua` including:
  - Mac-style movement (Cmd+Arrow, Option+Arrow)
  - Advanced clipboard operations with system register integration
  - Yanky clipboard navigation (Ctrl+p/n)
  - CodeCompanion Claude Code-style AI integration (Leader+c prefix)
- **AI Assistant**: CodeCompanion configured to mimic Claude Code behavior with:
  - Anthropic Claude models (Sonnet 3.5 default)
  - Review-first workflow (auto_submit disabled)
  - Custom prompts for code explanation, review, and assistance
  - VectorCode integration for semantic code search
  - MCP Hub integration for extended tool capabilities
- **Theme**: Tokyo Night Storm colorscheme
- **LSP**: Preconfigured Python support with Pyright

## Development Commands

### Code Formatting
```bash
stylua .  # Format Lua code (configured for 2-space indents, 120 column width)
```

### Plugin Management
LazyVim automatically manages plugins through lazy.nvim. Plugin updates and installations happen through the LazyVim interface within Neovim.

## File Patterns

- Plugin specifications: `lua/plugins/*.lua`
- Core configuration: `lua/config/*.lua`
- LazyVim settings: `lazyvim.json`
- Styling configuration: `stylua.toml`

## Important Notes

- The `lua/plugins/example.lua` file is disabled (`if true then return {} end`) and serves as reference documentation for plugin configuration patterns
- Configuration leverages LazyVim's plugin system - prefer extending existing LazyVim plugins over adding new ones
- Custom keymaps use a helper function for consistent defaults (noremap, silent)
- The configuration includes special handling for container environments and clipboard integration