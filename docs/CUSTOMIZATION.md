# Customization Guide

This guide covers customizing NovaOS themes, packages, and system configuration.

## 🎨 Themes

### Plymouth Boot Splash

Location: `themes/plymouth/`

Files:
- `nova-grub.png` - Background image (1920x1080)
- `nova.script` - Animation script
- `nova.plymouth` - Theme definition

Customizing:
1. Replace background image
2. Edit animation speed in `nova.script`
3. Rebuild with: `plymouth-set-default-theme nova`
4. Regenerate initramfs: `mkinitcpio -P`

### GRUB Theme

Location: `themes/grub/`

Files:
- `theme.txt` - Theme configuration
- `background.png` - Menu background
- `icons/` - Menu icons

Customizing:
1. Edit `theme.txt` for colors/fonts
2. Replace background image (recommended: 1920x1080)
3. Update GRUB: `grub-mkconfig -o /boot/grub/grub.cfg`

### SDDM Theme

Location: `themes/sddm/`

Files:
- `Theme.qml` - Main theme file
- `Background.qml` - Background component
- `Login.qml` - Login form
- `theme.conf` - Theme metadata

Customizing:
1. Modify QML files for layout changes
2. Update colors in `theme.conf`
3. Set theme: `cat /usr/share/sddm/themes/nova/theme.conf`

### KDE Plasma Theme

Location: `themes/kde/`

Components:
- `plasma/` - Plasma desktop theme
- `kvantum/` - Kvantum window decorations
- `konsole/` - Konsole color schemes
- `color-schemes/` - Color schemes

Customizing:
1. Copy themes to respective locations
2. Apply via System Settings
3. Or deploy system-wide with installation script

## 📦 Adding Packages

### Package Categories

- `packages/base/` - Core system packages
- `packages/gaming/` - Gaming software
- `packages/graphics/` - Graphics drivers

### Adding a Package

1. Determine package category
2. Add to appropriate file (alphabetically)
3. Include comment explaining purpose

Example:
```bash
# In packages/gaming/games.txt
# Retro game emulator
duckstation-qt
```

### AUR Packages

For AUR packages, add to `build-system/profiles/nova/packages/AUR.txt`

## ⚙️ System Configuration

### Kernel Parameters

Edit: `build-system/profiles/nova/boot-files/loader/entries/*.conf`

Common parameters:
```
# Performance tuning
processor.max_cstate=1
intel_pstate=disable
nvidia-drm.modeset=1

# Gaming
nowatchdog
nmi_watchdog=0
```

### sysctl Tuning

Location: `sysctl/`

Files:
- `gaming.conf` - Gaming optimizations
- `network.conf` - Network tuning

Apply with:
```bash
sudo sysctl -p /etc/sysctl.d/gaming.conf
```

### Service Configuration

Add/remove services in:
`build-system/profiles/nova/airootfs/etc/systemd/system/`

## 🖼️ Branding

### Wallpapers

Location: `branding/wallpapers/`

Add images to:
- `branding/wallpapers/1920x1080/`
- `branding/wallpapers/2560x1440/`

### Icons

Location: `branding/icons/`

Custom icon sets:
- `branding/icons/hicolor/` - Standard sizes
- `branding/icons/scalable/` - Scalable SVGs

### Sounds

Location: `branding/sounds/`

Files:
- `boot.wav` - Startup sound
- `shutdown.wav` - Shutdown sound
- `login.wav` - Login sound

Format: WAV, 44.1kHz, 16-bit stereo

## 🔧 Build-Time Customization

### Profile Variables

Edit: `build-system/profiles/nova/profile.conf`

```bash
# Profile name
NOVA_PROFILE_NAME="NovaOS"

# Version
NOVA_VERSION="1.0.0"

# ISO label
NOVA_ISO_LABEL="NovaOS"

# Bootloader
NOVA_BOOTLOADER="grub"
```

### Mirror Configuration

Set default mirror in:
`build-system/profiles/nova/mirrorlist`

## 📝 Post-Install Customization

### User Configuration

Template user configs:
`build-system/profiles/nova/airootfs/etc/skel/`

Files applied to new users:
- `.bashrc`
- `.config/kdeglobals`
- `.config/plasmarc`

### Automatic Configuration

Use pacman hooks for post-install:
`pacman-hooks/`

## Resources

- [Arch Wiki: Plymouth](https://wiki.archlinux.org/title/Plymouth)
- [Arch Wiki: GRUB](https://wiki.archlinux.org/title/GRUB)
- [SDDM Theme Guide](https://github.com/sddm/sddm/wiki/Theming)
- [KDE Plasma Theming](https://develop.kde.org/docs/plasma/)
