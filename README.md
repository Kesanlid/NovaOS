# NovaOS

A modern, gaming-focused Linux distribution based on Arch Linux.

![NovaOS](docs/images/banner.png)

## 🎮 Overview

NovaOS is a purpose-built Linux distribution optimized for gaming performance. Built on the solid foundation of Arch Linux, it combines the rolling-release model with carefully curated packages and optimizations to deliver an exceptional gaming experience.

### Key Features

- **Rolling Release Model** - Always up-to-date with the latest drivers and software
- **Gaming Optimized** - Pre-configured GameMode, MangoHud, and performance tuning
- **Multiple Game Launchers** - Steam, Heroic Games Launcher, and Lutris pre-installed
- **Vulkan Support** - Full Vulkan API support for AMD, Intel, and NVIDIA GPUs
- **Modern Desktop** - KDE Plasma with custom NovaOS theming
- **Fast Boot** - Plymouth splash, optimized boot process with zram
- **Btrfs Filesystem** - Copy-on-write snapshots for system protection

## 📦 What's Included

### Gaming Software
- Steam with Proton
- GameMode (Feral Interactive)
- MangoHud (overlay HUD)
- Lutris (game launcher)
- Heroic Games Launcher (Epic/GOG)
- Wine & Winetricks

### Graphics Drivers
- AMD GPU support (mesa, vulkan-radeon)
- Intel GPU support (intel-media-driver, vulkan-intel)
- NVIDIA GPU support (nvidia, nvidia-utils)

### Performance Features
- Preemptive kernel scheduling
- Low-latency audio configuration
- zram swap compression
- sysctl gaming optimizations
- CPU governor tuning

## 🔧 Building the ISO

### Prerequisites

```bash
# Install required packages on Arch Linux
sudo pacman -S archiso mkinitcpio-archiso

# Clone the repository
git clone https://github.com/novaos/novaos.git
cd novaos
```

### Build Command

```bash
# Run the build script
sudo ./build-system/build.sh --profile nova
```

The ISO will be created at `build-system/out/NovaOS-*.iso`

### Build Options

```bash
# Build with custom package mirror
sudo ./build-system/build.sh --profile nova --mirror https://mirror.example.com/archlinux/

# Build with debug mode
sudo ./build-system/build.sh --profile nova --debug
```

## 📁 Project Structure

```
novaos/
├── build-system/        # ISO build configuration
│   ├── profiles/        # Build profiles (nova)
│   ├── scripts/         # Build helper scripts
│   └── build.sh         # Main build script
├── packages/            # Package lists
│   ├── base/            # Base system packages
│   ├── gaming/          # Gaming packages
│   └── graphics/        # Graphics drivers
├── branding/            # Branding assets
│   ├── wallpapers/      # Desktop wallpapers
│   ├── sounds/          # Boot/shutdown sounds
│   ├── icons/           # Icon assets
│   └── fonts/           # Branding fonts
├── themes/              # UI themes
│   ├── plymouth/        # Boot splash theme
│   ├── grub/            # GRUB bootloader theme
│   ├── sddm/            # Login screen theme
│   └── kde/             # KDE Plasma theme
├── installer/            # Calamares configuration
├── sysctl/              # System tuning
├── pacman-hooks/        # Pacman hooks
└── docs/                # Documentation
```

## 🎨 Customization

### Changing the Theme

NovaOS includes a comprehensive theming system. To customize:

1. **KDE Plasma Theme**: Edit `themes/kde/plasma/`
2. **GRUB Theme**: Edit `themes/grub/`
3. **SDDM Theme**: Edit `themes/sddm/`
4. **Plymouth Theme**: Edit `themes/plymouth/`

### Adding Packages

To add packages to the ISO:

1. Add package names to the appropriate file in `packages/`
2. Rebuild the ISO with `./build-system/build.sh`

## 📚 Documentation

- [Building NovaOS](docs/BUILDING.md)
- [Customization Guide](docs/CUSTOMIZATION.md)
- [Gaming Setup](docs/GAMING.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) before submitting pull requests.

## 📄 License

NovaOS is released under the **GPL-3.0 License**. See [LICENSE](LICENSE) for details.

## 🔗 Links

- [Website](https://novaos.org)
- [Documentation](https://docs.novaos.org)
- [Community](https://community.novaos.org)
- [Bug Tracker](https://github.com/novaos/novaos/issues)

---

**NovaOS** - Gaming Redefined.