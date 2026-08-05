#!/usr/bin/env bash
#
# NovaOS Build Script
# Builds a bootable NovaOS ISO using ArchISO
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Default settings
PROFILE="nova"
OUTPUT_DIR="$SCRIPT_DIR/out"
WORK_DIR="$SCRIPT_DIR/work"
MIRROR="https://geo.mirror.pacman.org/archlinux"
DEBUG=false
CLEAN=false

# Print functions
info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Usage information
usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

NovaOS ISO Build Script

OPTIONS:
    --profile PROFILE      Build profile to use (default: nova)
    --mirror URL           Pacman mirror URL (default: Arch global)
    --out DIR             Output directory (default: ./out)
    --work DIR            Working directory (default: ./work)
    --debug               Enable debug mode
    --clean               Clean build artifacts before building
    -h, --help            Show this help message

EXAMPLES:
    $(basename "$0") --profile nova
    $(basename "$0") --profile nova --mirror https://mirror.us.leaseweb.net/archlinux/
    $(basename "$0") --profile nova --clean --debug

EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --profile)
            PROFILE="$2"
            shift 2
            ;;
        --mirror)
            MIRROR="$2"
            shift 2
            ;;
        --out)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --work)
            WORK_DIR="$2"
            shift 2
            ;;
        --debug)
            DEBUG=true
            shift
            ;;
        --clean)
            CLEAN=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    warn "Running as root. This is required for building ISOs."
fi

# Check for required tools
check_dependencies() {
    local deps=(mkarchiso pacstrap)
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &>/dev/null; then
            error "Missing dependency: $dep"
            error "Please install archiso: sudo pacman -S archiso"
            exit 1
        fi
    done
    # Install mkinitcpio if missing (needed for initramfs)
    if ! command -v mkinitcpio &>/dev/null; then
        info "Installing mkinitcpio..."
        pacman -S --noconfirm mkinitcpio
    fi
}

# Clean build directory
clean() {
    if [[ -d "$WORK_DIR" ]]; then
        info "Cleaning work directory..."
        rm -rf "$WORK_DIR"
    fi
    if [[ -d "$OUTPUT_DIR" ]]; then
        info "Cleaning output directory..."
        rm -rf "$OUTPUT_DIR"
    fi
    success "Cleaned build directories."
}

# Create directory structure
create_directories() {
    info "Creating build directories..."
    mkdir -p "$OUTPUT_DIR"
    mkdir -p "$WORK_DIR"
    success "Directories created."
}

# Configure mirror
configure_mirror() {
    info "Configuring package mirror: $MIRROR"
    cat > /tmp/nova-mirrorlist << EOF
# NovaOS Custom Mirror
Server = $MIRROR/\$repo/os/\$arch
EOF
    mkdir -p "$WORK_DIR/airootfs/etc/pacman.d"
    cp /tmp/nova-mirrorlist "$WORK_DIR/airootfs/etc/pacman.d/mirrorlist"
    success "Mirror configured."
}

# Copy profile files
copy_profile() {
    local profile_dir="$SCRIPT_DIR/profiles/$PROFILE"
    
    if [[ ! -d "$profile_dir" ]]; then
        error "Profile not found: $PROFILE"
        exit 1
    fi
    
    info "Copying profile: $PROFILE"
    cp -r "$profile_dir/." "$WORK_DIR/"
    success "Profile copied."
}

# Read packages from file
read_packages() {
    local pkg_file="$1"
    if [[ -f "$pkg_file" ]]; then
        grep -v '^#' "$pkg_file" | grep -v '^$' | sed "s|^|${SCRIPT_DIR}/|"
    fi
}

# Collect all packages
collect_packages() {
    info "Collecting packages..."
    
    local pkg_dir="$SCRIPT_DIR/../packages"
    local all_packages=()
    
    # Base packages
    for pkg_file in \
        "$pkg_dir/base/core.txt" \
        "$pkg_dir/base/desktop.txt"; do
        if [[ -f "$pkg_file" ]]; then
            while IFS= read -r pkg; do
                [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
                all_packages+=("$pkg")
            done < "$pkg_file"
        fi
    done
    
    # Gaming packages
    for pkg_file in \
        "$pkg_dir/gaming/steam.txt" \
        "$pkg_dir/gaming/gaming-tools.txt" \
        "$pkg_dir/gaming/wine.txt"; do
        if [[ -f "$pkg_file" ]]; then
            while IFS= read -r pkg; do
                [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
                all_packages+=("$pkg")
            done < "$pkg_file"
        fi
    done
    
    # Graphics packages (all included for maximum compatibility)
    for pkg_file in \
        "$pkg_dir/graphics/amd.txt" \
        "$pkg_dir/graphics/intel.txt" \
        "$pkg_dir/graphics/nvidia.txt"; do
        if [[ -f "$pkg_file" ]]; then
            while IFS= read -r pkg; do
                [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
                all_packages+=("$pkg")
            done < "$pkg_file"
        fi
    done
    
    # Write combined package list
    printf '%s\n' "${all_packages[@]}" > "$WORK_DIR/packages.list"
    success "Collected ${#all_packages[@]} packages."
    
    # Also create packages.x86_64 for archiso in the profile directory
    local profile_dir="$SCRIPT_DIR/profiles/$PROFILE"
    printf '%s\n' "${all_packages[@]}" > "$profile_dir/packages.x86_64"
    success "Created packages.x86_64 for archiso."
    
    # Create pacman.conf for the profile (required by mkarchiso)
    local pacman_conf="$profile_dir/pacman.conf"
    cat > "$pacman_conf" << 'PACMAN_EOF'
[options]
Architecture = auto
SigLevel = Never
LocalFileSigLevel = Never
CheckSpace
OverwriteDirs

[core]
Server = https://geo.mirror.pacman.org/archlinux/$repo/os/$arch

[extra]
Server = https://geo.mirror.pacman.org/archlinux/$repo/os/$arch

[community]
Server = https://geo.mirror.pacman.org/archlinux/$repo/os/$arch
PACMAN_EOF
    success "Created pacman.conf for archiso."
    
    # Also sync pacman databases before build
    info "Syncing pacman databases..."
    pacman -Sy --noconfirm || true
}

# Build the ISO
build_iso() {
    info "Starting ISO build..."
    
    # Set environment variables
    export PACKAGES="$WORK_DIR/packages.list"
    export OUTPUT="$OUTPUT_DIR"
    export WORK="$WORK_DIR"
    
    # Build command
    local mkarchiso_args=(
        -v
        -w "$WORK_DIR"
        -o "$OUTPUT_DIR"
        "$SCRIPT_DIR/profiles/$PROFILE"
    )
    
    if [[ "$DEBUG" == true ]]; then
        mkarchiso_args+=(-debug)
    fi
    
    # Run mkarchiso
    if mkarchiso "${mkarchiso_args[@]}"; then
        success "ISO built successfully!"
        ls -lh "$OUTPUT_DIR"/*.iso 2>/dev/null || true
    else
        error "ISO build failed!"
        exit 1
    fi
}

# Post-build tasks
post_build() {
    info "Running post-build tasks..."
    
    # Generate checksums
    if [[ -f "$OUTPUT_DIR"/*.iso ]]; then
        for iso in "$OUTPUT_DIR"/*.iso; do
            info "Generating SHA256 for $(basename "$iso")..."
            sha256sum "$iso" > "${iso}.sha256"
        done
    fi
    
    success "Post-build tasks completed."
}

# Main function
main() {
    echo ""
    echo "╔══════════════════════════════════════════════╗"
    echo "║         NovaOS ISO Build Script              ║"
    echo "║         Gaming-Focused Arch Linux            ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""
    
    check_dependencies
    
    if [[ "$CLEAN" == true ]]; then
        clean
    fi
    
    create_directories
    copy_profile
    configure_mirror
    collect_packages
    build_iso
    post_build
    
    echo ""
    echo "╔══════════════════════════════════════════════╗"
    echo "║              Build Complete!                 ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""
    info "ISO location: $OUTPUT_DIR"
    info "Package list: $WORK_DIR/packages.list"
    echo ""
}

# Run main
main
