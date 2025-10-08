# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a LazyVim-based Neovim configuration that uses Lua for all configuration files. The setup follows LazyVim's structure with custom plugins and configurations.

## Architecture

- **init.lua**: Main entry point that bootstraps lazy.nvim and sets up basic LSP configuration
- **lua/config/**: Core configuration files (options, keymaps, autocmds, lazy setup)
- **lua/plugins/**: Individual plugin configurations (18+ custom plugin files)
- **prompts/**: Custom prompt templates for CodeCompanion integration

### Key Components

1. **Plugin Management**: Uses lazy.nvim with automatic plugin loading
2. **LSP Setup**: Pyright LSP with custom keybindings in init.lua
3. **CodeCompanion Integration**: AI coding assistant with custom prompts and Claude.md integration
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
- `lua/plugins/codecompanion.lua` - AI assistant with custom prompt integration
- `lua/plugins/repl.lua` - REPL functionality
- `lua/plugins/telescope.lua` - Fuzzy finder configuration
- `lua/plugins/copilot-custom.lua` - GitHub Copilot integration

### Prompt Templates
- `prompts/claude_prefix.md` - Base Claude Code instructions
- `prompts/data_science_expert.md` - Python/data science specific prompts

## Development Notes

### CodeCompanion Integration
The CodeCompanion plugin is configured to automatically read:
1. `~/.config/nvim/prompts/claude_prefix.md` - Base instructions
2. `CLAUDE.md` from current working directory - Project-specific context

This allows for context-aware AI assistance that understands both the Neovim environment and specific project requirements.

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