#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
THEME_DIR="$DOTFILES_DIR/.theme-repos"

echo "=== Linux Dotfiles Setup ==="

# Kopier git config
cp "$DOTFILES_DIR/config/.gitconfig" ~/.gitconfig
echo "Git config installert."

# Installer Google Chrome
if ! command -v google-chrome &>/dev/null; then
    echo ""
    echo "--- Installerer Google Chrome ---"
    wget -O /tmp/google-chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    sudo apt install -y /tmp/google-chrome.deb
    rm /tmp/google-chrome.deb
    echo "Google Chrome installert."
fi

# Installer VS Code
if ! command -v code &>/dev/null; then
    echo ""
    echo "--- Installerer VS Code ---"
    wget -O /tmp/vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
    sudo apt install -y /tmp/vscode.deb
    rm /tmp/vscode.deb
    echo "VS Code installert."
fi

# Installer Slack
if ! command -v slack &>/dev/null; then
    echo ""
    echo "--- Installerer Slack ---"
    wget -O /tmp/slack.deb "https://downloads.slack-edge.com/desktop-releases/linux/x64/4.41.105/slack-desktop-4.41.105-amd64.deb"
    sudo apt install -y /tmp/slack.deb
    rm /tmp/slack.deb
    echo "Slack installert."
fi

# Installer Spotify
if ! command -v spotify &>/dev/null; then
    echo ""
    echo "--- Installerer Spotify ---"
    curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    sudo apt update && sudo apt install -y spotify-client
    echo "Spotify installert."
fi

# Installer apt-pakker
echo ""
echo "--- Installerer apt-pakker ---"
xargs -a "$DOTFILES_DIR/linux/packages.txt" sudo apt install -y

# Installer snap-pakker
echo ""
echo "--- Installerer snap-pakker ---"
while IFS= read -r line; do
    [ -z "$line" ] && continue
    sudo snap install $line
done < "$DOTFILES_DIR/linux/snaps.txt"

# WhiteSur macOS Sonoma-tema
echo ""
echo "--- Installerer WhiteSur macOS Sonoma-tema ---"
mkdir -p "$THEME_DIR"

# GTK-tema
if [ ! -d "$THEME_DIR/WhiteSur-gtk-theme" ]; then
    git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git "$THEME_DIR/WhiteSur-gtk-theme"
fi
"$THEME_DIR/WhiteSur-gtk-theme/install.sh" -l -N glassy
"$THEME_DIR/WhiteSur-gtk-theme/tweaks.sh" -F -c Light

# Ikon-tema
if [ ! -d "$THEME_DIR/WhiteSur-icon-theme" ]; then
    git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git "$THEME_DIR/WhiteSur-icon-theme"
fi
"$THEME_DIR/WhiteSur-icon-theme/install.sh"

# Cursor-tema
if [ ! -d "$THEME_DIR/WhiteSur-cursors" ]; then
    git clone https://github.com/vinceliuice/WhiteSur-cursors.git "$THEME_DIR/WhiteSur-cursors"
fi
"$THEME_DIR/WhiteSur-cursors/install.sh"

# Wallpapers
if [ ! -d "$THEME_DIR/WhiteSur-wallpapers" ]; then
    git clone https://github.com/vinceliuice/WhiteSur-wallpapers.git "$THEME_DIR/WhiteSur-wallpapers"
fi
"$THEME_DIR/WhiteSur-wallpapers/install-gnome-backgrounds.sh"

echo "WhiteSur-tema installert."

# Sett tema via gsettings
echo ""
echo "--- Setter GNOME-tema ---"
gsettings set org.gnome.desktop.interface gtk-theme 'WhiteSur-Light'
gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur'
gsettings set org.gnome.desktop.interface cursor-theme 'WhiteSur-cursors'
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'

# Tastatur: swap Alt/Cmd(Super) og Ctrl/Alt
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:swap_lalt_lctl', 'altwin:swap_alt_win']"

# GNOME extensions
echo ""
echo "--- GNOME extensions ---"
echo "Installer disse via Extension Manager:"
cat "$DOTFILES_DIR/linux/gnome-extensions.txt"

# Last inn GNOME-innstillinger
echo ""
read -p "Vil du laste inn GNOME-innstillinger (dock, blur, tastatur, osv.)? [j/N] " svar
if [ "$svar" = "j" ] || [ "$svar" = "J" ]; then
    dconf load /org/gnome/desktop/ < "$DOTFILES_DIR/gnome/desktop.dconf"
    dconf load /org/gnome/shell/ < "$DOTFILES_DIR/gnome/shell.dconf"
    echo "GNOME-innstillinger lastet inn."
fi

echo ""
echo "=== Ferdig! Logg ut og inn igjen for at alt skal ta effekt. ==="
