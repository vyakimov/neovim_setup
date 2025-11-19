# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a LazyVim-based Neovim configuration that uses Lua for all configuration files. The setup follows LazyVim's structure with custom plugins and configurations.

## Architecture

- **init.lua**: Main entry point that bootstraps lazy.nvim and sets up basic LSP configuration
- **lua/config/**: Core configuration files (options, keymaps, autocmds, lazy setup)
- **lua/plugins/**: Individual plugin configurations (16 custom plugin files)
- **prompts/**: Custom prompt templates for CodeCompanion integration

### Key Components

1. **Plugin Management**: Uses lazy.nvim with automatic plugin loading
2. **LSP Setup**: Pyright LSP with custom keybindings in init.lua
3. **CodeCompanion Integration**: AI coding assistant with:
   - Custom prompts and CLAUDE.md integration
   - Memory support for persistent context across sessions
   - MCP Hub integration for additional tools and resources
   - VectorCode semantic search integration
   - Both HTTP and ACP (Agent Client Protocol) adapters
4. **Custom Keymaps**: Extensive macOS-style keybindings with system clipboard integration
5. **Theme**: Tokyo Night Storm colorscheme

## Common Commands

### Code Formatting
```bash
# Format Lua files using stylua (configured with 2-space indentation, 120 column width)
stylua .
```

### Plugin Management
```bash
# Inside Neovim - update plugins
:Lazy update

# Check plugin status
:Lazy
```

### CodeCompanion Usage
- `<leader>cq` - CodeCompanion Actions menu
- `<leader>cd` - Toggle CodeCompanion Chat
- `<leader>cD` - Open new CodeCompanion Chat
- `<leader>ci` (visual) - Inline replace with CodeCompanion

## Configuration Patterns

### Plugin Structure
Each plugin file in `lua/plugins/` follows this pattern:
- Single plugin per file (mostly)
- Configuration in `opts` table or `config` function
- Lazy loading where appropriate

### Custom Keymaps
The configuration uses a custom `map()` function defined in `lua/config/keymaps.lua` that sets default options (`noremap = true, silent = true`).

### System Integration
- **Clipboard**: Smart clipboard handling with OSC52 support for containers/tmux
- **LSP**: Custom Python LSP setup with signature help on Ctrl+Space
- **Yanky**: Enhanced yank/paste operations with system clipboard integration

## Important Files

### Core Configuration
- `lua/config/options.lua` - Smart clipboard setup for different environments
- `lua/config/keymaps.lua` - macOS-style movement and editing keybindings
- `lua/config/lazy.lua` - Plugin manager configuration with performance optimizations

### Key Plugins
- `lua/plugins/codecompanion.lua` - AI assistant with custom prompt integration, memory, MCP Hub, and VectorCode
- `lua/plugins/mcphub.lua` - MCP Hub integration for additional tools and resources
- `lua/plugins/vectorcode.lua` - Semantic code search integration
- `lua/plugins/mini.diff.lua` - Enhanced diff display for CodeCompanion
- `lua/plugins/repl.lua` - REPL functionality
- `lua/plugins/telescope.lua` - Fuzzy finder configuration
- `lua/plugins/copilot-custom.lua` - GitHub Copilot integration
- `lua/plugins/copilot-lsp.lua` - Copilot LSP integration
- `lua/plugins/bookmarks.lua` - Bookmark management
- `lua/plugins/yanky.lua` - Enhanced yank/paste operations

### Prompt Templates
- `prompts/claude_prefix.md` - Base Claude Code instructions
- `prompts/data_science_expert.md` - Python/data science specific prompts

## Development Notes

### CodeCompanion Integration
The CodeCompanion plugin is configured with advanced features:

**Prompt Loading**:
1. `~/.config/nvim/prompts/claude_prefix.md` - Base instructions
2. `CLAUDE.md` from current working directory - Project-specific context

**AI Models Available**:
- **Chat strategy**: OpenAI GPT-5.1 (default), GPT-5 Mini
- **Inline strategy**: Anthropic Claude Sonnet 4.5 (2025-09-29), Claude Opus 4.1
- **Agent strategy**: Claude Code via ACP (Agent Client Protocol)

**Memory System**:
- Persistent context across chat sessions
- Automatically enabled for chat interactions

**Extensions**:
- **MCP Hub**: Provides additional tools, resources, and slash commands from MCP servers
- **VectorCode**: Semantic code search using embeddings (default 10 results, max 20)

**Adapters**:
- **HTTP adapters**: Direct API access to OpenAI and Anthropic
- **ACP adapters**: Agent Client Protocol support for Claude Code and Codex
- Authentication via environment variables (ANTHROPIC_API_KEY, OPENAI_API_KEY, CLAUDE_CODE_OAUTH_TOKEN)

### Custom Keybinding Philosophy
- macOS-style text navigation (Cmd+Arrow, Option+Arrow)
- System clipboard operations with `<leader>` prefix
- Yanky integration for enhanced paste operations
- Quick exit from insert mode with 'jk'

### Environment Compatibility
The configuration automatically adapts to different environments:
- Container/Docker environments with OSC52 clipboard
- Tmux integration for clipboard operations
- Fallback to standard clipboard when not in containers