# Building NovaOS

This guide covers the complete process of building a NovaOS ISO from source.

## Prerequisites

### System Requirements

- **OS**: Arch Linux (or NovaOS)
- **Architecture**: x86_64
- **RAM**: 4GB minimum (8GB recommended)
- **Disk Space**: 30GB free space
- **CPU**: Any x86_64 processor

### Required Packages

```bash
# Install build dependencies
sudo pacman -S archiso mkinitcpio-archiso git base-devel

# Optional but recommended
sudo pacman -S ccache
```

## Quick Start

```bash
# Clone the repository
git clone https://github.com/novaos/novaos.git
cd novaos

# Build the ISO
sudo ./build-system/build.sh --profile nova
```

The ISO will be created at: `build-system/out/NovaOS-*-x86_64.iso`

## Build Options

### Command Line Options

| Option | Description | Default |
|--------|-------------|---------|
| `--profile` | Build profile to use | nova |
| `--mirror` | Package mirror URL | Arch Linux global |
| `--debug` | Enable debug mode | false |
| `--clean` | Clean build artifacts | false |
| `--out` | Output directory | ./out |

### Examples

```bash
# Use specific mirror
sudo ./build-system/build.sh --profile nova --mirror https://mirror.us.leaseweb.net/archlinux/

# Debug build with verbose output
sudo ./build-system/build.sh --profile nova --debug

# Clean build
sudo ./build-system/build.sh --profile nova --clean
```

## Build Process

### 1. Preparation

The build script:
- Validates the build environment
- Creates necessary directories
- Copies profile configuration

### 2. Package Installation

ArchISO:
- Creates a new root filesystem
- Installs packages from `packages/base`
- Installs packages from `packages/gaming`
- Installs packages from `packages/graphics`
- Installs AUR packages if configured

### 3. Configuration

The build system:
- Applies NovaOS branding
- Configures Plymouth splash
- Configures GRUB theme
- Configures SDDM theme
- Configures KDE Plasma theme
- Sets up performance optimizations
- Configures Calamares installer

### 4. ISO Creation

Final steps:
- Creates initramfs images
- Configures bootloader
- Packages filesystem into ISO
- Creates hybrid ISO image

## Build Customization

### Adding Custom Packages

Edit `packages/gaming/extra.txt`:
```
# My custom gaming package
my-custom-package
```

### Modifying Kernel Parameters

Edit `build-system/profiles/nova/boot-files/grub/grub.cfg`

### Changing Desktop Environment

Modify packages in `packages/base/desktop.txt`

## Troubleshooting

### Build Fails with Permission Errors

Ensure you're running with sudo:
```bash
sudo ./build-system/build.sh --profile nova
```

### Out of Disk Space

Increase available space or clean cache:
```bash
./build-system/build.sh --clean
```

### Package Download Failures

Try a different mirror:
```bash
sudo ./build-system/build.sh --profile nova --mirror https://mirror.example.com/
```

## Advanced Build Options

### Using ccache

```bash
export CCACHE_DIR=/path/to/ccache
sudo ./build-system/build.sh --profile nova
```

### Building in Chroot

For development, build without sudo using arch-chroot:
```bash
./build-system/scripts/dev-build.sh --profile nova
```

## Verification

After building, verify the ISO:

```bash
# Check ISO file exists
ls -lh build-system/out/NovaOS-*.iso

# Verify ISO structure (requires libisoburn)
isohybrid --verbose build-system/out/NovaOS-*.iso

# Test with QEMU (optional)
qemu-system-x86_64 -cdrom build-system/out/NovaOS-*.iso -m 4G
```

## Continuous Integration

NovaOS uses GitHub Actions for automated builds. See `.github/workflows/` for configuration.

## Next Steps

- [Customization Guide](CUSTOMIZATION.md)
- [Gaming Setup](GAMING.md)
- [Troubleshooting](TROUBLESHOOTING.md)
