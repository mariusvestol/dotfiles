# Dotfiles - Linux (Ubuntu) med macOS Sonoma-look

Automatisk oppsett av en fersk Ubuntu-installasjon med macOS Sonoma-utseende og alle verktøyene jeg bruker. Kjør ett script og alt er på plass.

## Bruk

```bash
git clone https://github.com/mariusvestol/dotfiles.git
cd dotfiles
./setup.sh
```

Scriptet spør om sudo-passord underveis. Etter at det er ferdig, logg ut og inn igjen for at alt skal ta effekt.

## Hva scriptet gjør

### 1. Apper (installeres som .deb / apt)
- **Google Chrome** - lastes ned direkte fra Google
- **VS Code** - lastes ned direkte fra Microsoft
- **Slack** - lastes ned direkte fra Slack
- **Spotify** - legges til som apt-repo og installeres

### 2. apt-pakker
btop, git, ripgrep, wireshark, flameshot, guake, gnome-tweaks, LaTeX, nodejs, python3, build-essential, m.m.

Se `linux/packages.txt` for full liste.

### 3. Snap-apper
- Blender
- Todoist

### 4. WhiteSur macOS Sonoma-tema
Kloner og installerer automatisk:
- **GTK-tema** - WhiteSur-Light med glassy topbar
- **Ikoner** - WhiteSur icon theme
- **Cursors** - WhiteSur cursors
- **Wallpapers** - WhiteSur nord wallpapers

### 5. GNOME-innstillinger
Laster inn dconf-innstillinger for:
- Dock i bunn (autohide, macOS-stil)
- Vindu-knapper til venstre (close, minimize, maximize)
- Norsk tastatur med Ctrl/Alt-swap
- Blur-effekter og search light-snarvei (Alt+S)

### 6. GNOME Extensions (manuelt)
Disse må installeres manuelt via Extension Manager etter at scriptet er ferdig:
- **Dash to Dock** - macOS-lignende dock
- **Blur my Shell** - blur-effekter på shell og dock
- **Search Light** - spotlight-lignende søk
- **Compiz Magic Lamp Effect** - minimerings-animasjon
- **Tiling Assistant** - vindushåndtering

## Filstruktur

```
dotfiles/
├── setup.sh                    # Hovedscript - kjør dette
├── config/
│   └── .gitconfig              # Git-bruker og innstillinger
├── linux/
│   ├── packages.txt            # apt-pakker (en per linje)
│   ├── snaps.txt               # snap-pakker (en per linje)
│   └── gnome-extensions.txt    # GNOME extensions-liste
└── gnome/
    ├── desktop.dconf           # GNOME desktop-innstillinger
    └── shell.dconf             # GNOME shell/extensions-innstillinger
```

## Tilpassing

- Legg til/fjern pakker i `linux/packages.txt` eller `linux/snaps.txt`
- Eksporter dine egne GNOME-innstillinger med:
  ```bash
  dconf dump /org/gnome/desktop/ > gnome/desktop.dconf
  dconf dump /org/gnome/shell/ > gnome/shell.dconf
  ```
