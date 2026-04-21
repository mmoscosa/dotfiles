#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$HOME/Code/dotfiles"
echo "Ghost Protocol — dotfiles installer"
echo "===================================="

# 1. Homebrew
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 2. Brew bundle
echo "Installing packages..."
brew bundle --file="$DOTFILES/Brewfile"

# 3. Stow packages
echo "Symlinking configs..."
cd "$DOTFILES"
for pkg in ghostty tmux starship git demux shell; do
  echo "  stow $pkg"
  stow --restow "$pkg" 2>/dev/null || stow --adopt "$pkg"
done

# Bin goes to ~/bin
mkdir -p "$HOME/bin"
stow --restow -t "$HOME/bin" bin 2>/dev/null || stow -t "$HOME/bin" --adopt bin

# 4. TPM
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
fi

# 5. TPM plugins
echo "Installing tmux plugins..."
~/.config/tmux/plugins/tpm/bin/install_plugins

# 6. FZF keybindings
if [ ! -f "$HOME/.fzf.zsh" ]; then
  echo "Setting up fzf keybindings..."
  $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

# 7. Append zshrc.d sourcing if not present
if ! grep -q "zshrc.d" "$HOME/.zshrc" 2>/dev/null; then
  echo "" >> "$HOME/.zshrc"
  echo "# Source modular configs" >> "$HOME/.zshrc"
  echo 'for f in ~/.zshrc.d/*.zsh(N); do source "$f"; done' >> "$HOME/.zshrc"
fi

# 8. Seed local (untracked) aliases file from template on first install
LOCAL_ALIASES="$DOTFILES/shell/.zshrc.d/aliases.local.zsh"
if [ ! -f "$LOCAL_ALIASES" ]; then
  cp "$LOCAL_ALIASES.example" "$LOCAL_ALIASES"
  echo "Seeded $LOCAL_ALIASES from template."
fi

echo ""
echo "Done! Restart Ghostty or run: source ~/.zshrc"
echo ""
echo "⚠  Private aliases (e.g. claudio) aren't tracked in this repo."
echo "   Edit ~/.zshrc.d/aliases.local.zsh to add them — it's gitignored."
