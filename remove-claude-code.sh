#!/bin/bash

echo "Removing Claude Code from your system..."

# Remove the npm global package directories
echo "1. Removing Claude Code npm directories..."
rm -rf /opt/homebrew/lib/node_modules/@anthropic-ai/claude-code
rm -rf /opt/homebrew/lib/node_modules/@anthropic-ai/.claude-code-*

# Remove the symlink
echo "2. Removing claude binary symlink..."
rm -f /opt/homebrew/bin/claude

# Clean npm cache
echo "3. Cleaning npm cache..."
rm -rf ~/.npm/_cacache

# Optional: Remove Claude Code config (comment out if you want to keep your settings)
echo "4. Removing Claude Code configuration..."
# Uncomment the next line if you want to remove all config:
# rm -rf ~/.claude

echo "Done! Claude Code has been removed."
echo "You can now run: npm i -g @anthropic-ai/claude-code"
