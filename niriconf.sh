sudo zypper refresh

sudo zypper install \
    alacritty \
    waybar \
    fuzzel \
    swaync \
    swaylock \
    thunar \
    brightnessctl \
    wireplumber \
    wl-clipboard \
    xwayland-satellite


// ========================================
// NIRI CONFIGURATION
// ========================================


// ----------------------------------------
// INPUT
// ----------------------------------------

input {
    keyboard {

        xkb {
        layout = "latam"
     }

        repeat-delay 600
        repeat-rate 25
    }

    touchpad {
        tap
        natural-scroll
    }

    mouse {
        accel-speed 0.2
    }

    focus-follows-mouse max-scroll-amount="0%"
}


// ----------------------------------------
// LAYOUT
// ----------------------------------------

layout {
    gaps 8

    center-focused-column "never"

    default-column-width {
        proportion 0.60
    }

    preset-column-widths {
        proportion 0.50
        proportion 0.60
        proportion 0.75
        proportion 1.00
    }

    focus-ring {
        width 2
        active-color "#89b4fa"
        inactive-color "#45475a"
        urgent-color "#f38ba8"
    }

    border {
        off
    }

    shadow {
        off
    }

    background-color "#1e1e2e"
}


// ----------------------------------------
// STARTUP
// ----------------------------------------

spawn-at-startup "waybar"
spawn-at-startup "swaync"


// ----------------------------------------
// APPEARANCE
// ----------------------------------------

prefer-no-csd

hotkey-overlay {
    skip-at-startup
}


// ----------------------------------------
// KEYBINDINGS
// ----------------------------------------

binds {

    // TERMINAL
    Mod+Return { spawn "alacritty"; }

    // APPLICATIONS
    Mod+D { spawn "fuzzel"; }
    Mod+E { spawn "thunar"; }
    Mod+B { spawn "brave"; }

    // WINDOW MANAGEMENT
    Mod+Q { close-window; }
    Mod+F { maximize-column; }
    Mod+Shift+F { fullscreen-window; }

    // FOCUS
    Mod+H { focus-column-left; }
    Mod+L { focus-column-right; }
    Mod+J { focus-window-down; }
    Mod+K { focus-window-up; }

    // MOVE WINDOWS
    Mod+Shift+H { move-column-left; }
    Mod+Shift+L { move-column-right; }
    Mod+Shift+J { move-window-down; }
    Mod+Shift+K { move-window-up; }

    // COLUMN MANAGEMENT
    Mod+BracketLeft { consume-window-into-column; }
    Mod+BracketRight { expel-window-from-column; }

    // COLUMN WIDTH
    Mod+R { switch-preset-column-width; }
    Mod+Shift+R { switch-preset-window-height; }

    // WORKSPACES
    Mod+1 { focus-workspace 1; }
    Mod+2 { focus-workspace 2; }
    Mod+3 { focus-workspace 3; }
    Mod+4 { focus-workspace 4; }
    Mod+5 { focus-workspace 5; }

    Mod+Shift+1 { move-window-to-workspace 1; }
    Mod+Shift+2 { move-window-to-workspace 2; }
    Mod+Shift+3 { move-window-to-workspace 3; }
    Mod+Shift+4 { move-window-to-workspace 4; }
    Mod+Shift+5 { move-window-to-workspace 5; }

    // OVERVIEW
    Mod+O { toggle-overview; }

    // NOTIFICATIONS
    Mod+N { spawn "swaync-client" "-t"; }

    // SCREENSHOT
    Print { screenshot; }

    // LOCK SCREEN
    Mod+Escape { spawn "swaylock"; }

    // VOLUME
    XF86AudioRaiseVolume {
        spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+";
    }

    XF86AudioLowerVolume {
        spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-";
    }

    XF86AudioMute {
        spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle";
    }

    // EXIT
    Mod+Shift+E { quit; }
}
