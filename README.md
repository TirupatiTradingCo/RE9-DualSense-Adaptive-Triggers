# Resident Evil Requiem – DualSense Adaptive Triggers + Controller Tools

[![Stars](https://img.shields.io/github/stars/TirupatiTradingCo/RE9-DualSense-Adaptive-Triggers)](https://github.com/TirupatiTradingCo/RE9-DualSense-Adaptive-Triggers)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**Bring the full PS5 DualSense experience to Resident Evil Requiem on PC** – adaptive triggers for every weapon, dynamic LED health indicator, gyro aiming, and advanced haptic feedback. Fully compatible with REFramework and DualSenseX (DSX).

---

## ⚠️ Disclaimer
This repository is for **educational purposes only**. All tools and scripts are provided as-is. Use at your own risk. This mod does not modify game files, only communicates with DSX via UDP.

---

## 📦 Why This Mod?

Capcom did not include native DualSense support in the PC version of Resident Evil Requiem. That means:
- No adaptive trigger resistance when firing weapons
- No dynamic LED changes based on health
- No gyro aiming
- No advanced haptics

**This mod fixes all of that** by hooking into REFramework and sending real-time weapon and ammo data to DualSenseX (DSX) via UDP.

---

## ✨ Features

### 🎯 Adaptive Triggers

| Weapon Type | Trigger Effect |
|-------------|----------------|
| **Pistols** | Light, consistent resistance with a crisp break at the firing point |
| **Shotguns** | Heavy, stiff pull that mimics the weight of a shotgun |
| **Magnums (Killer7)** | Extremely heavy resistance, breaks only at full pull |
| **Rifles** | Medium resistance with a smooth pull |
| **Empty Magazine** | Trigger instantly goes limp, giving you physical feedback that you're out of ammo |
| **Melee** | No resistance (feels like a dead trigger) |

### 💡 Dynamic LED

- **Green** – Healthy (75-100% HP)
- **Yellow** – Caution (25-75% HP)
- **Red** – Danger (Below 25% HP)
- **Flashing Red** – Critical (Below 10% HP)
- **White** – Healing item used (temporary flash)

### 🧭 Gyro Aiming

- Enable precise motion controls for aiming
- Adjustable sensitivity
- Toggle on/off with touchpad click

### 🔊 Advanced Haptics

- Different vibration patterns for each weapon type
- Footstep haptics based on surface
- Environmental feedback (rain, explosions)

### ⚙️ In-Game Configuration

All features can be configured through a custom REFramework menu:
- Toggle adaptive triggers on/off
- Adjust trigger resistance strength
- Calibrate gyro sensitivity
- Choose LED color scheme
- Test all features in real-time

---

## 📥 Download

Password-protected archive with the complete DualSense toolset.

📥 **[Download `RE9-DualSense-Pack.zip`](dist/RE9-DualSense-Pack.zip)**  
🔐 **Password:** `RE9ds2026`

### Archive Contents
- `DSX-UDP-Client.exe` – UDP client for DSX communication
- `scripts/` – REFramework Lua scripts (autorun folder)
- `DSX-Profile.dsx` – Pre-configured DSX profile
- `README.txt` – Instructions

---

## 🛠️ Requirements

- **PS5 DualSense Controller**
- **REFramework** (latest nightly build for RE9) – [Download from praydog's GitHub](https://github.com/praydog/REFramework)
- **DualSenseX (DSX)** – Available on Steam
- **Windows 10/11**

---

## 🎮 Installation

### Step 1: Install REFramework
1. Download the latest RE9 version of REFramework
2. Extract `dinput8.dll` to your RE9 game folder (where `RE9.exe` is located)

### Step 2: Install DSX
1. Purchase and install DSX from Steam
2. Launch DSX at least once to complete setup
3. In DSX settings, ensure UDP is enabled:
   - Go to **Networking** tab
   - Enable all UDP settings
   - Set controller emulation to **Xbox 360**

### Step 3: Install the Mod
1. Run `DSX-UDP-Client.exe` **as Administrator** (just once – it will auto-start with Windows)
2. Copy all `.lua` files from the `scripts/` folder to:
   `[RE9 Game Folder]\reframework\autorun\`
3. Copy `DSX-Profile.dsx` to your DSX profiles folder (usually `Documents\DSX\Profiles\`)

### Step 4: Launch
1. Start DSX
2. Run the UDP client (if not already running)
3. Launch Resident Evil Requiem
4. Press **INSERT** to open REFramework menu
5. Navigate to **Script Generated UI** → **DualSense Tools**

---

## 🔧 Configuration

### In-Game REFramework Menu

| Option | Description |
|--------|-------------|
| **Enable Adaptive Triggers** | Master toggle for all trigger effects |
| **Trigger Strength** | Adjust resistance intensity (50-200%) |
| **Enable LED** | Toggle dynamic health LED |
| **LED Brightness** | Adjust LED brightness |
| **Enable Gyro Aiming** | Turn motion controls on/off |
| **Gyro Sensitivity** | Adjust motion aiming sensitivity |
| **Gyro Activation** | Choose when gyro activates (always, while aiming, touchpad) |
| **Enable Haptics** | Master toggle for vibration effects |
| **Haptic Intensity** | Adjust vibration strength |
| **Connection Status** | Shows UDP client connection state |

### DSX Profile
The included `DSX-Profile.dsx` has pre-configured settings optimized for RE9. You can load it in DSX and customize further.

---

## 🎮 How It Works

The mod uses a two-part architecture:

1. **REFramework Lua Scripts** hook into the game engine to track:
   - Current weapon type
   - Ammo count
   - Player health percentage
   - Current action (firing, aiming, healing)

2. **UDP Client** receives data from the scripts and sends formatted commands to DSX

3. **DSX** translates these commands into actual controller feedback

This means no memory injection, no game file modification – just safe, external communication.

---

## 🔫 Weapon-Specific Trigger Profiles

| Weapon | Resistance | Break Point | Notes |
|--------|------------|-------------|-------|
| M1911 Pistol | 40% | 80% pull | Smooth, consistent |
| W-870 Shotgun | 80% | 95% pull | Heavy, sudden break |
| Killer7 Magnum | 95% | 98% pull | Extremely heavy |
| CQBR Rifle | 60% | 85% pull | Medium, smooth |
| Rocket Launcher | 100% | N/A | Full lock until fired |
| Knife | 0% | N/A | No resistance |
| Empty Weapon | 0% | N/A | Instantly goes limp |

---

## 🩺 LED Health Indicators

| Health % | LED Color | Effect |
|----------|-----------|--------|
| 100-75% | Green | Solid |
| 74-50% | Yellow | Solid |
| 49-25% | Orange | Solid |
| 24-10% | Red | Solid |
| 9-0% | Red | Rapid flashing |
| Using herb | White | Quick flash |
| Using spray | White | Double flash |
| Taking damage | Red | Quick pulse |

---

## ❗ Troubleshooting

| Problem | Solution |
|---------|----------|
| **Triggers not working** | Ensure DSX is running and UDP is enabled in DSX settings |
| **UDP client won't connect** | Run as Administrator. Check Windows Firewall |
| **LED not changing** | Verify LED is enabled in REFramework menu |
| **Game crashes after installing scripts** | Update REFramework to latest nightly build |
| **DSX not detecting controller** | Make sure controller is connected via USB (Bluetooth has limitations) |
| **Laggy gyro aiming** | Reduce sensitivity or use USB connection instead of Bluetooth |
| **Antivirus false positive** | Add UDP client to exclusions – it's a false positive |

---

## 📜 License
MIT License – educational purposes only.

---

## ⭐ Support
If this mod enhanced your RE9 experience with a DualSense controller, please **star the repository**!

**Credits:**
- Original concept and UDP client by lunati_ 
- Adapted for RE9 by TirupatiTradingCo
- REFramework by praydog
- DSX by Paliverse
