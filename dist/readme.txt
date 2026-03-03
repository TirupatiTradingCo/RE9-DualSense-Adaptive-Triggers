============================================================
RESIDENT EVIL REQUIEM - DUAL SENSE ADAPTIVE TRIGGERS PACK
============================================================

Password: RE9ds2026

FILES INCLUDED:
- DSX-UDP-Client.exe       (UDP client for DSX communication)
- scripts/                 (REFramework Lua scripts)
- DSX-Profile.dsx          (pre-configured DSX profile)

REQUIREMENTS:
- PS5 DualSense controller
- REFramework (latest nightly build) - https://github.com/praydog/REFramework
- DualSenseX (DSX) - available on Steam
- Windows 10/11

INSTALLATION:

1. Install REFramework:
   - Download latest RE9 version
   - Extract dinput8.dll to game folder (where RE9.exe is)

2. Install DSX from Steam:
   - Launch DSX at least once
   - Go to Networking tab → enable all UDP settings
   - Set controller emulation to Xbox 360

3. Install this mod:
   - Run DSX-UDP-Client.exe as Administrator (first time only)
   - Copy all .lua files from scripts/ folder to:
     [game folder]\reframework\autorun\
   - Copy DSX-Profile.dsx to:
     Documents\DSX\Profiles\

4. Launch:
   - Start DSX
   - Run UDP client (if not already running)
   - Launch RE9
   - Press INSERT in-game → Script Generated UI → DualSense Tools

FEATURES:
- Adaptive triggers for all weapon types (pistol, shotgun, magnum, rifle)
- Empty magazine feedback (trigger goes limp)
- Dynamic LED based on health (green/yellow/red/flashing)
- Gyro aiming with adjustable sensitivity
- Advanced haptics

TROUBLESHOOTING:
- No triggers: Ensure DSX is running and UDP is enabled
- LED not changing: Check LED is enabled in REFramework menu
- UDP client won't connect: Run as Administrator, check firewall
- Game crashes: Update REFramework to latest nightly

NOTE: Antivirus may false-positive on UDP client - it's safe.
Add to exclusions if needed.

Enjoy the full DualSense experience!