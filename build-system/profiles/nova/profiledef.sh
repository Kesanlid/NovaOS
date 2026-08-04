#!/usr/bin/env bash
# shellcheck disable=SC2034
# NovaOS Profile Definition for ArchISO

# ISO settings
iso_name="NovaOS"
iso_label="NOVAOS"
iso_publisher="NovaOS Team <https://novaos.tech>"
iso_application="NovaOS Live/Installation"
iso_version="1.0.0"
install_dir="nova"

# Build modes
buildmodes=('iso')

# Boot modes
bootmodes=('bios.syslinux' 'uefi.systemd-boot')

# Pacman configuration
pacman_conf="pacman.conf"

# Airootfs image settings
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86,arm64' '-b' '1M' '-Xdict-size' '1M')
