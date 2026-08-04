#!/usr/bin/env bash
# NovaOS Profile Definition for ArchISO
# This file defines the packages and configuration for NovaOS

set -e

# Profile information
export PROFILE_NAME="NovaOS"
export PROFILE_VERSION="1.0.0"
export PROFILE_DESCRIPTION="A gaming-focused Arch Linux distribution"

# Architecture
export ARCH="x86_64"

# ISO settings
export ISO_NAME="NovaOS"
export ISO_VERSION="${PROFILE_VERSION}"
export ISO_PUBLISHER="NovaOS Team"
export ISO_APPLICATION="NovaOS Live/Installation"
export ISO_VOLUME_ID="NovaOS-${ISO_VERSION}"

# Bootloader
export BOOTLOADER="grub"

# Installation
export INSTALL_MODE="normal"

# Build directories
export WORK_DIR="work"
export OUT_DIR="out"

# Package files to include
PACKAGE_FILES=(
    "packages/base/core.txt"
    "packages/base/desktop.txt"
    "packages/gaming/steam.txt"
    "packages/gaming/gaming-tools.txt"
    "packages/gaming/wine.txt"
    "packages/graphics/amd.txt"
    "packages/graphics/intel.txt"
    "packages/graphics/nvidia.txt"
)

# Build function
build_profile() {
    # Profile-specific build steps would go here
    echo "Building NovaOS profile..."
}
