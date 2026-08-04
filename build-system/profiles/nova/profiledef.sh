#!/usr/bin/env bash
# NovaOS Profile Definition for ArchISO

# Profile name
_profile_name="NovaOS"
_version="1.0.0"

# Architecture
_arch="x86_64"

# ISO settings
_iso_name="NovaOS"
_iso_publisher="NovaOS Team"
_iso_application="NovaOS Live/Installation"
_iso_volume_id="NovaOS-${_version}"
_iso_version="${_version}"

# Bootloader
_bootloader="grub"

# Installation mode
_install_mode="normal"

# Build directories
_work_dir="work"
_out_dir="out"

# Package list (handled by build.sh via packages.x86_64)
# _pkg_list=""
