
#!/usr/bin/env bash
set -Eeuo pipefail

if ! command -v zypper >/dev/null 2>&1; then
    echo "Este script requiere openSUSE."
    exit 1
fi

CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP="$HOME/backup-niri-$(date +%Y%m%d-%H%M%S)"

echo "==> Creando respaldo..."
mkdir -p "$BACKUP"

for dir in niri waybar fuzzel alacritty gtk-3.0 gtk-4.0; do
    if [[ -e "$CONFIG/$dir" ]]; then
        cp -a "$CONFIG/$dir" "$BACKUP/"
    fi
done

echo "Respaldo: $BACKUP"

echo "==> Instalando paquetes..."

PACKAGES=(
    niri
    waybar
    fuzzel
    alacritty
    swaybg
    papirus-icon-theme
    breeze-cursors
    jetbrains-mono-fonts
)

for package in "${PACKAGES[@]}"; do
    sudo zypper --non-interactive install "$package" || \
        echo "Aviso: no se pudo instalar $package"
done

mkdir -p "$CONFIG/niri" "$CONFIG/waybar" \
         "$CONFIG/fuzzel" "$CONFIG/alacritty" "$CONFIG/gtk-3.0"

echo "==> Configurando Niri..."

cat > "$CONFIG/niri/config.kdl" <<'KDL'
environment {
    XCURSOR_THEME "breeze_cursors"
    XCURSOR_SIZE "24"
    XDG_CURRENT_DESKTOP "niri"
    XDG_SESSION_TYPE "wayland"
}

cursor {
    xcursor-theme "breeze_cursors"
    xcursor-size 24
}

input {
    keyboard {
        xkb {
            layout "us"
        }
    }
    touchpad {
        tap
    }
}

binds {
    Mod+Return { spawn "alacritty"; }
    Mod+D { spawn "fuzzel"; }
    Mod+Shift+E { quit; }
}

spawn-at-startup "waybar"
KDL

echo "==> Configurando Waybar..."

cat > "$CONFIG/waybar/config.jsonc" <<'JSON'
{
  "layer": "top",
  "position": "top",
  "height": 28,
  "spacing": 0,
  "modules-left": ["niri/workspaces"],
  "modules-center": ["clock"],
  "modules-right": ["cpu", "memory", "pulseaudio", "tray"],

  "niri/workspaces": {
    "format": "{index}",
    "all-outputs": true,
    "disable-scroll": true
  },

  "clock": {
    "format": "{:%d %b  %H:%M}",
    "tooltip": false
  },

  "cpu": {
    "format": "CPU {usage}%",
    "interval": 3
  },

  "memory": {
    "format": "RAM {percentage}%",
    "interval": 5
  },

  "pulseaudio": {
    "format": "VOL {volume}%",
    "format-muted": "VOL MUTED"
  },

  "tray": {
    "spacing": 8
  }
}
JSON

cat > "$CONFIG/waybar/style.css" <<'CSS'
* {
    font-family: "JetBrains Mono";
    font-size: 11px;
    font-weight: 500;
    border: none;
    border-radius: 0;
    min-height: 0;
}

window#waybar {
    background: #000000;
    color: #ffffff;
}

#workspaces {
    padding: 0 8px;
}

#workspaces button {
    color: #777777;
    background: transparent;
    padding: 0 10px;
}

#workspaces button.active {
    color: #ffffff;
    background: #292929;
}

#workspaces button:hover {
    color: #ffffff;
    background: #383838;
}

#clock {
    color: #ffffff;
    padding: 0 12px;
}

#cpu, #memory, #pulseaudio, #tray {
    color: #ffffff;
    padding: 0 10px;
}

tooltip {
    background: #000000;
    color: #ffffff;
    border: 1px solid #444444;
}
CSS

echo "==> Configurando Fuzzel..."

cat > "$CONFIG/fuzzel/fuzzel.ini" <<'INI'
[main]
font=JetBrains Mono:size=11
prompt="Run: "
width=45
lines=8
horizontal-pad=20
vertical-pad=12
inner-pad=8
layer=overlay
terminal=alacritty

[colors]
background=000000f2
text=ffffffff
prompt=aaaaaaff
placeholder=777777ff
input=ffffffff
match=ffffffff
selection=333333ff
selection-text=ffffffff
selection-match=ffffffff
border=666666ff

[border]
width=1
radius=4
INI

echo "==> Configurando Alacritty..."

cat > "$CONFIG/alacritty/alacritty.toml" <<'TOML'
[window]
padding = { x = 10, y = 10 }
opacity = 0.96

[font]
size = 11.0
normal = { family = "JetBrains Mono" }

[colors.primary]
background = "#000000"
foreground = "#ffffff"

[colors.normal]
black = "#1a1a1a"
red = "#d75f5f"
green = "#87af87"
yellow = "#d7af5f"
blue = "#5f87af"
magenta = "#af87af"
cyan = "#5f8787"
white = "#d7d7d7"

[colors.bright]
black = "#626262"
red = "#ff8787"
green = "#afd7af"
yellow = "#ffd787"
blue = "#87afd7"
magenta = "#d7afd7"
cyan = "#87afaf"
white = "#ffffff"
TOML

echo "==> Configurando GTK..."

cat > "$CONFIG/gtk-3.0/settings.ini" <<'GTK'
[Settings]
gtk-theme-name=adw-gtk3-dark
gtk-icon-theme-name=Papirus-Dark
gtk-cursor-theme-name=breeze_cursors
gtk-cursor-theme-size=24
GTK

gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark' 2>/dev/null || true
gsettings set org.gnome.desktop.interface cursor-theme 'breeze_cursors' 2>/dev/null || true
gsettings set org.gnome.desktop.interface cursor-size 24 2>/dev/null || true

echo
echo "==> Validando configuración..."

if command -v niri >/dev/null 2>&1; then
    niri validate || echo "Revisa los errores de configuración de Niri."
fi

echo
echo "======================================"
echo " Niri instalado y configurado."
echo " Respaldo: $BACKUP"
echo "======================================"
echo
echo "Reinicia tu sesión para aplicar los cambios."
