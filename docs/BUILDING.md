# SantiagoEngine Bulding.

---

## Table of Contents
1. [Dependencies](#dependencies)  
2. [Building Instructions](#building-instructions)  
3. [Troubleshooting](#troubleshooting)  
4. [Need Help?](#need-help)

---

## Dependencies

### All Platforms
- **Git** ([Download](https://git-scm.com/))
- **Haxe 4.3.4 or newer** ([Download](https://haxe.org/download/))

### Windows
- **Microsoft Visual Studio Community 2022**  
  Required Components:
  - `Microsoft.VisualStudio.Component.VC.Tools.x86.x64`
  - `Microsoft.VisualStudio.Component.Windows10SDK.19041`

### Linux
- **VLC** (for video playback support)
- **g++** (for compilation)

### macOS
- **Xcode Command Line Tools** (for compilation)

---

## Building Instructions

### Windows
1. Install **Git** and **Haxe**.
2. Install **Visual Studio 2022** with the required components listed above.
3. Open a terminal in the repository root and run:
   ```bash
   cd setup
   windows.bat
   ```
4. Return to the root directory and compile with:
   ```bash
   lime test plataform
   ```

### Linux
1. Install dependencies:  
   **Ubuntu/Debian**:
   ```bash
   sudo add-apt-repository ppa:haxe/releases -y
   sudo apt update
   sudo apt install haxe libvlc-dev libvlccore-dev g++ -y
   ```
   **Arch/Manjaro**:
   ```bash
   sudo pacman -Syu haxe git vlc gcc --noconfirm
   ```
2. Set up Haxelib:
   ```bash
   mkdir ~/haxelib && haxelib setup ~/haxelib
   ```
3. Run the setup script:
   ```bash
   cd setup
   ./unix.sh
   ```
4. Compile the project:
   ```bash
   lime test cpp
   ```

### macOS
1. Install **Xcode Command Line Tools**:
   ```bash
   xcode-select --install
   ```
2. Install **Haxe** and **Git** (via Homebrew or official installers).
3. Set up Haxelib:
   ```bash
   mkdir ~/haxelib && haxelib setup ~/haxelib
   ```
4. Run the setup script:
   ```bash
   cd setup
   ./unix.sh
   ```
5. Compile the project:
   ```bash
   lime test cpp
   ```

---

## Troubleshooting

### Common Issues
1. **Linux: "g++ not found"**  
   Install `g++` via your package manager:
   - Debian/Ubuntu: `sudo apt install g++`
   - Arch: `sudo pacman -S gcc`

2. **Windows: "LNK1120 unresolved externals"**  
   Clean the build and recompile:
   ```bash
   lime test cpp -clean
   ```
   If the issue persists, delete the `export` folder and rebuild.

3. **Haxelib Setup Errors**  
   Ensure the correct path is set for Haxelib. Run:
   ```bash
   haxelib setup
   ```
   and confirm the path points to `.haxelib` (Windows) or `~/haxelib` (Linux/macOS).

4. **VLC Errors on Linux**  
   Install both `libvlc-dev` and `libvlccore-dev`:
   ```bash
   sudo apt install libvlc-dev libvlccore-dev
   ```

---

**Note**: First-time builds may take 5–10 minutes depending on your hardware.