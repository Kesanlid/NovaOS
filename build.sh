#!/bin/bash
# NovaOS Build Script - Simple & Robust
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/build"
OUT_DIR="$SCRIPT_DIR/output"

echo "=========================================="
echo " NovaOS ISO Builder"
echo "=========================================="

# Clean
rm -rf "$BUILD_DIR" "$OUT_DIR"
mkdir -p "$BUILD_DIR" "$OUT_DIR"

# Setup profile
PROFILE_DIR="$SCRIPT_DIR/profile"
rm -rf "$PROFILE_DIR/airootfs/var/lib/pacman" 2>/dev/null || true
rm -rf "$PROFILE_DIR/airootfs/var/cache" 2>/dev/null || true
mkdir -p "$PROFILE_DIR/airootfs/var/lib" 2>/dev/null || true

# Collect packages
echo "[1/4] Collecting packages..."
PKGS=()
for f in "$SCRIPT_DIR"/packages/**/*.txt; do
    [[ -f "$f" ]] || continue
    while IFS= read -r p; do
        p=$(echo "$p" | sed 's/#.*//' | xargs)
        [[ -n "$p" ]] && PKGS+=("$p")
    done < "$f"
done
printf '%s\n' "${PKGS[@]}" | sort -u > "$PROFILE_DIR/packages.x86_64"
echo "      $(wc -l < "$PROFILE_DIR/packages.x86_64") packages"

# Create pacman.conf with OverwriteDirs
echo "[2/4] Configuring pacman..."
cat > "$PROFILE_DIR/pacman.conf" << 'PACCONF'
[options]
Architecture = auto
SigLevel = Never
LocalFileSigLevel = Never
OverwriteDirs

[core]
Server = https://geo.mirror.pacman.org/archlinux/$repo/os/$arch

[extra]
Server = https://geo.mirror.pacman.org/archlinux/$repo/os/$arch

[community]
Server = https://geo.mirror.pacman.org/archlinux/$repo/os/$arch
PACCONF

# Copy profiledef
echo "[3/4] Setting up profile..."
cat > "$PROFILE_DIR/profiledef.sh" << 'PROFDEF'
iso_name="NovaOS"
iso_label="NOVAOS"
iso_publisher="NovaOS Team"
iso_application="NovaOS Live"
iso_version="1.0.0"
install_dir="nova"
buildmodes=('iso')
bootmodes=('bios.syslinux' 'uefi.systemd-boot')
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-b' '1M')
PROFDEF

# Sync pacman
echo "[4/4] Syncing pacman..."
pacman -Sy --noconfirm || true

# Build
echo ""
echo "Building ISO..."
mkarchiso -v -w "$BUILD_DIR" -o "$OUT_DIR" "$PROFILE_DIR"

echo ""
echo "=========================================="
echo " DONE! ISO: $OUT_DIR/"
ls -lh "$OUT_DIR/"
echo "=========================================="
