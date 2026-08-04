# Troubleshooting Guide

Common issues and solutions for NovaOS.

## 🚀 Boot Issues

### System Won't Boot

**Symptoms:** Black screen, kernel panic, or infinite boot loop.

**Solutions:**

1. **Check boot parameters:**
   - Press `e` at GRUB menu
   - Remove `quiet splash` for verbose output
   - Check for hardware compatibility

2. **Try fallback kernel:**
   ```
   GRUB: Advanced options → Arch Linux, fallback
   ```

3. **Check GPU drivers:**
   - If NVIDIA: Add `nomodeset` to boot parameters
   - If AMD: Usually works out of the box

4. **Check filesystem:**
   - Boot from live USB
   - Run `fsck` on root partition
   - Check `/var/log/` for errors

### Plymouth Not Showing

**Solutions:**

1. **Regenerate initramfs:**
   ```bash
   sudo mkinitcpio -P
   ```

2. **Rebuild Plymouth:**
   ```bash
   sudo plymouth-set-default-theme nova
   sudo mkinitcpio -P
   ```

3. **Check Plymouth logs:**
   ```bash
   sudo plymouth --debug
   journalctl -b | grep plymouth
   ```

### GRUB Not Showing

**Solutions:**

1. **Reinstall GRUB:**
   ```bash
   sudo grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=NovaOS
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   ```

2. **Restore GRUB menu timeout:**
   ```bash
   # Edit /etc/default/grub
   GRUB_TIMEOUT=5
   sudo grub-mkconfig -o /boot/grub/grub.cfg
   ```

## 🖥️ Display Issues

### Black Screen After Login

**Symptoms:** Login works but desktop doesn't appear.

**Solutions:**

1. **Switch to different TTY:**
   ```
   Ctrl+Alt+F2 → Login → startx
   ```

2. **Check Plasma:**
   ```bash
   # Reset Plasma config
   mv ~/.config/plasma-workspace ~/.config/plasma-workspace.bak
   # Or for system-wide:
   sudo mv /etc/skel/.config/plasma-workspace ~/.config/plasma-workspace.bak
   ```

3. **Check X11/Wayland:**
   ```bash
   # Check logs
   cat ~/.xsession-errors
   journalctl -xe | grep plasma
   ```

### Resolution Issues

**Solutions:**

1. **Using xrandr:**
   ```bash
   xrandr --output HDMI-1 --mode 1920x1080
   ```

2. **Create persistent configuration:**
   ```bash
   # Edit /etc/X11/xorg.conf.d/10-monitor.conf
   Section "Monitor"
       Identifier "HDMI-1"
       Option "PreferredMode" "1920x1080"
   EndSection
   ```

### NVIDIA Specific Issues

**Black screen on boot:**
```bash
# Add to /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="nvidia-drm.modeset=1"
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

**Performance issues:**
```bash
# Enable PRIME sync
# Edit /etc/modprobe.d/nvidia.conf
options nvidia_drm modeset=1
options nvidia_drm fbdev=1
```

## 🎮 Gaming Issues

### Steam Not Launching

**Solutions:**

1. **Fix Steam runtime:**
   ```bash
   rm ~/.steam/steam/runtime/amd64-linux/u_runtime.tar.xz
   steam --reset
   ```

2. **Check library files:**
   ```bash
   # If games missing
   steam://validate
   ```

3. **Fix font issues:**
   ```bash
   # Install missing fonts
   sudo pacman -S steam-fonts 2>/dev/null || true
   ```

### Games Running Slowly

**Diagnosis:**
```bash
# Check FPS with MangoHud
MANGOHUD=1 ./game

# Check GPU usage
nvidia-smi  # NVIDIA
radeontop   # AMD

# Check CPU frequency
watch -n 1 "grep MHz /proc/cpuinfo"
```

**Solutions:**

1. **Enable GameMode:**
   ```bash
   gamemoded -i
   gamemoderun ./game
   ```

2. **Disable compositor:**
   ```bash
   # Temporary
   kquitapp5 plasma && kstart5 plasma

   # Permanent (for specific games)
   # Set in system settings → Display → Compositor
   ```

3. **Check wine prefix:**
   ```bash
   # Create new prefix with proper settings
   WINEPREFIX=~/.wine-new WINEARCH=win64 winecfg
   ```

### Proton Games Won't Start

**Solutions:**

1. **Check compatibility:**
   - Visit [ProtonDB](https://www.protondb.com/)
   - Check for known issues

2. **Enable Proton logging:**
   ```bash
   # In Steam launch options
   PROTON_LOG=1 %command%
   # Check logs in ~/.steam/steam/logs/
   ```

3. **Try different Proton version:**
   - Proton Experimental (latest)
   - Proton 8.0, 7.0, etc.

## 🔊 Audio Issues

### No Sound

**Solutions:**

1. **Restart PipeWire:**
   ```bash
   systemctl --user restart pipewire pipewire-pulse
   ```

2. **Check default device:**
   ```bash
   pavucontrol
   # Set correct output device
   ```

3. **Reset ALSA:**
   ```bash
   pulseaudio -k && pulseaudio -D
   ```

### Audio Stuttering

**Solutions:**

1. **Check for IRQ conflicts:**
   ```bash
   cat /proc/interrupts | grep -i audio
   ```

2. **Increase buffer size:**
   ```bash
   # Edit /etc/pulse/daemon.conf
   default-fragments = 4
   default-fragment-size-msec = 10
   ```

## 📦 Package Issues

### Pacman Database Error

**Solutions:**

1. **Refresh package database:**
   ```bash
   sudo pacman -Syy
   ```

2. **Fix signature issues:**
   ```bash
   sudo pacman-key --init
   sudo pacman-key --populate archlinux
   sudo pacman -Sc
   ```

### Broken Dependencies

**Solutions:**

1. **Force reinstall:**
   ```bash
   sudo pacman -Syyu
   ```

2. **Fix broken package:**
   ```bash
   sudo pacman -S package-name --overwrite '*'
   ```

## 🌐 Network Issues

### No Internet Connection

**Solutions:**

1. **Check connection:**
   ```bash
   ip link
   ping archlinux.org
   ```

2. **Restart network:**
   ```bash
   # systemd-networkd
   sudo systemctl restart systemd-networkd
   
   # NetworkManager
   sudo systemctl restart NetworkManager
   ```

3. **Check DHCP:**
   ```bash
   sudo dhcpcd -k
   sudo dhcpcd
   ```

## 📋 Getting Help

### Collect System Information

```bash
# Generate system report
inxi -Fxxx

# Save to file
inxi -Fxxx > system-info.txt

# Show logs
journalctl -b -p err
```

### Useful Commands

| Command | Purpose |
|---------|---------|
| `systemctl status service` | Check service status |
| `journalctl -xe` | View detailed logs |
| `dmesg \| grep -i error` | Check kernel messages |
| `lsblk` | List block devices |
| `cat /proc/cpuinfo` | CPU information |
| `lspci \| grep -i vga` | GPU information |

### Where to Get Help

1. **NovaOS Issues:** [GitHub Issues](https://github.com/novaos/novaos/issues)
2. **Arch Wiki:** [archlinux.org/wiki](https://wiki.archlinux.org/)
3. **Discord:** [NovaOS Community](https://discord.gg/novaos)
4. **Reddit:** [r/novaos](https://reddit.com/r/novaos)

## Emergency Recovery

### Live USB Boot

1. Boot from NovaOS live USB
2. Mount your system:
   ```bash
   sudo mount /dev/sda2 /mnt
   sudo mount /dev/sda1 /mnt/boot
   arch-chroot /mnt
   ```

3. Fix issues
4. Reboot

### Reset Password

1. Boot to GRUB
2. Edit boot entry, add `init=/bin/bash`
3. Remount filesystem: `mount -o remount,rw /`
4. Reset password: `passwd username`
5. Reboot

### Reinstall Bootloader

```bash
# Boot from live USB
sudo mount /dev/sda2 /mnt
sudo arch-chroot /mnt
sudo grub-install /dev/sda
sudo grub-mkconfig -o /boot/grub/grub.cfg
```
