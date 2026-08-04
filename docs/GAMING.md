# Gaming Setup Guide

This guide covers gaming configuration and optimization on NovaOS.

## 🎮 Pre-installed Software

### Steam

Steam is pre-installed with Proton support enabled.

**First Launch Setup:**
1. Log in to Steam
2. Enable Steam Play for all titles (Settings → Steam Play)
3. Install games!

**Proton Configuration:**
```bash
# Use latest Proton (recommended)
STEAM compat tool: Proton Experimental

# Or use specific version
STEAM compat tool: Proton 8.0-x
```

### GameMode

GameMode is automatically enabled for Steam games. For Lutris/custom launchers:

**Manual Activation:**
```bash
gamemoderun ./game-executable
```

**Configuration:**
```bash
# Edit GameMode settings
nano ~/.config gamemode.ini
```

### MangoHud

MangoHud displays FPS and system metrics overlay.

**Steam Setup:**
1. Add game to Steam
2. Launch options:
```
MANGOHUD=1 mangohud %command%
```

**Lutris Setup:**
1. Game Configuration → Game Options
2. Prefix command: `MANGOHUD=1 mangohud`

**Keybindings:**
- `F2` - Toggle MangoHud
- `F3` - Toggle FPS limit
- `Shift+F12` - Toggle all overlays

## 🕹️ Game Launchers

### Heroic Games Launcher

Epic Games and GOG launcher.

**First Launch:**
1. Launch from Application Menu
2. Sign in to Epic/GOG
3. Configure wine prefix location

**Recommended Settings:**
- Wine Version: Proton (for Epic) / System (for GOG)
- DXVK/VKD3D: Enabled
- Gamemode: Enabled
- MangoHud: Enabled

### Lutris

Open source game launcher supporting multiple platforms.

**Adding Games:**
1. Click "+" to add game
2. Select installer source
3. Follow installer wizard

**Optimized Settings:**
- Runner: Auto-detect or specify
- DXVK: Enabled for AMD/NVIDIA
- GameMode: Enabled
- MangoHud: Enabled

## ⚡ Performance Optimizations

### CPU Governor

NovaOS ships with performance-oriented CPU settings.

**Check Current Governor:**
```bash
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

**Set Performance Mode:**
```bash
# Temporary
sudo cpupower frequency-set -g performance

# Permanent (already configured in NovaOS)
# Edit /etc/default/cpupower
```

### GameMode Settings

File: `/etc/gamemode.ini` (system-wide)
File: `~/.config/gamemode.ini` (per-user)

```ini
[general]
renice=10

[custom]
# Custom scripts to run
start=notify-send "GameMode started"
end=notify-send "GameMode ended"
```

### NVIDIA Settings

**nvidia-settings:**
```bash
# Open NVIDIA control panel
nvidia-settings

# Recommended settings:
# PowerMizer: Prefer Maximum Performance
# Anti-aliasing: Let the application decide
```

**NVIDIA Thread Optimization:**
```bash
# Add to /etc/environment
__GL_THREAD_OPTIMIZATION=1
__GL_SHADER_DISK_CACHE=1
__GL_SHADER_DISK_CACHE_PATH=/home/username/.nv/GLSL-cache
```

### AMD Settings

**AMDconfig:**
```bash
# Enable FreeSync
amdgpu-modprobe $USER
amdgpu-freesync=1

# Check current mode
amdcontrol -g performance
```

**RADV Settings:**
```bash
# Add to /etc/environment
RADV_PERFTEST=gpl
```

## 🎯 Latency Optimization

### Games with Stuttering Issues

**Proton/Steam:**
```bash
# Add to game launch options
RADV_PERFTEST=gpl %command%
```

**Lutris:**
```bash
# Enable DXVK_ASYNC in environment
DXVK_ASYNC=1
```

### Audio Latency

**PipeWire (default):**
```bash
# Check audio server
pactl info | grep "Server Name"

# Set real-time priority (already configured)
# Check with:
pactl list sink-inputs
```

**ALSA (if used):**
```bash
# Edit /etc/security/limits.d/audio.conf
@audio - rtprio 95
@audio - memlock unlimited
```

## 🛠️ Troubleshooting

### Proton Games Won't Launch

1. Check Proton version (try Experimental)
2. Verify graphics drivers
3. Check game logs: `~/.steam/steam/logs/`
4. Try: `PROTON_LOG=1 %command%`

### Poor Performance

1. Check GPU utilization: `MANGOHUD=1`
2. Disable desktop effects: `kwin_x11 --replace &`
3. Close other applications
4. Check thermals: `sensors`

### Stuttering/Freezing

1. Enable VSync in game settings
2. Check for DXVK/VKD3D issues
3. Disable shader cache if causing problems
4. Try different Wine/Proton version

### Audio Issues

1. Restart PipeWire: `systemctl --user restart pipewire`
2. Check audio device: `pavucontrol`
3. Set games to use correct output

## 📊 Benchmarking

### FPS Benchmarks

```bash
# Using MangoHud
MANGOHUD=1 mangohud --fps-only ./game

# Using libstrangle for framerate cap testing
libstrangle 60 ./game
```

### System Monitoring

```bash
# Watch system stats
watch -n 1 'cat /proc/interrupts | head -20'

# GPU monitoring
nvidia-smi -l 1  # NVIDIA
radeontop -l 1   # AMD
```

## 🎮 Game-Specific Fixes

### Epic Games via Heroic

- Enable "Use Wine/Proton"
- Set DLL overrides for anti-cheat
- Try Epic Online Services Linux

### Windows Games

1. Check WineHQ AppDB for fixes
2. Try different Wine/Proton versions
3. Check winetricks requirements

## Resources

- [ProtonDB](https://www.protondb.com/) - Game compatibility ratings
- [WineHQ AppDB](https://appdb.winehq.org/) - Windows app compatibility
- [Lutris Docs](https://lutris.readthedocs.io/) - Lutris documentation
- [Heroic Wiki](https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/wiki)
