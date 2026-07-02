#curl -fLo ~/.local/share/fonts/JetBrainsMono.zip \

# JetBrainsMono
curl -fLo ~/.local/share/fonts/JetBrainsMono.zip \
  https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
unzip ~/.local/share/fonts/JetBrainsMono.zip -d ~/.local/share/fonts/JetBrainsMono
fc-cache -fv

# Alacritty looks for its config at ~/.config/alacritty/alacritty.toml by
# default, so symlink this repo's copy there instead of relying on a manual copy.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ln -sf "$SCRIPT_DIR/alacritty.toml" ~/.config/alacritty/alacritty.toml
ln -sf "$SCRIPT_DIR/cappuccin-latte.toml" ~/.config/alacritty/cappuccin-latte.toml
