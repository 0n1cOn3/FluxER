<h1 align="center">🔒 FluxER</h1>
<h3 align="center">Fluxion Easy Runner for Termux</h3>
<p align="center">Automated installer and launcher for Fluxion - a wireless security auditing toolkit for WPA/WPA2 testing and network analysis in Termux environments.</p>

---

<div align="center">

[![Issues](https://img.shields.io/github/issues/0n1cOn3/FluxER?style=flat-square)](https://github.com/0n1cOn3/FluxER/issues)
[![Pull Requests](https://img.shields.io/github/issues-pr/0n1cOn3/FluxER?style=flat-square)](https://github.com/0n1cOn3/FluxER/pulls)
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-yellow.svg?style=flat-square)](https://opensource.org/licenses/GPL-3.0)
[![Version](https://img.shields.io/badge/version-1.0-blue.svg?style=flat-square)](https://github.com/0n1cOn3/FluxER/releases)

</div>

---

## 🎯 Features

- **Automated Setup**: One-command installation of Ubuntu (proot) and Fluxion
- **Optimized for Termux**: Efficient resource usage and mobile-friendly
- **No Root Required**: Works on non-rooted Android devices
- **Smart Package Management**: Only installs necessary dependencies
- **Error Handling**: Robust installation with detailed progress feedback
- **Storage Efficient**: Optional components to minimize space usage

---

## ⚠️ Important Announcement

<div align="center">

### 🚨 32-BIT SUPPORT ENDING DECEMBER 31, 2025 🚨

**ARM64 (64-bit) only for main releases starting 2026**

[Beta x86/x64 Support Branch →](https://github.com/0n1cOn3/FluxER/tree/Beta-x86-and-x64-support)

</div>

---

## 📋 Requirements

### Minimum Requirements
- **OS**: Termux on Android 7.0+
- **Architecture**: ARM64 (64-bit) - *Latest Release*
  - ARM32 (32-bit) support available in [beta branch](https://github.com/0n1cOn3/FluxER/tree/Beta-x86-and-x64-support)
- **Storage**: ~500MB-1GB free space
- **Internet**: Stable connection for downloads
- **Permissions**: Storage access (granted during setup)

### Recommended
- Android 9.0 or higher
- 2GB+ free storage for optimal performance
- Wi-Fi connection for faster downloads

---

## 🚀 Installation

### Quick Start

1. **Install Termux** from [F-Droid](https://f-droid.org/packages/com.termux/) (recommended) or GitHub

2. **Update Termux packages**:
   ```bash
   pkg update && pkg upgrade -y
   ```

3. **Clone the repository**:
   ```bash
   git clone https://github.com/0n1cOn3/FluxER.git
   cd FluxER
   ```

4. **Make the script executable**:
   ```bash
   chmod +x fluxer.sh
   ```

5. **Run FluxER**:
   ```bash
   ./fluxer.sh
   ```

The installer will:
- Request storage permissions
- Install required dependencies
- Download and setup Ubuntu (proot)
- Install Fluxion and wireless tools
- Provide launch instructions

---

## 💻 Usage

### First Launch
After installation completes, start Fluxion with:

```bash
cd ~
./start-ubuntu.sh
cd fluxion
./fluxion.sh
```

### Quick Launch (One-liner)
```bash
./start-ubuntu.sh -c 'cd fluxion && ./fluxion.sh'
```

### Create an Alias (Optional)
Add to `~/.bashrc` for easy access:
```bash
echo "alias fluxion='~/start-ubuntu.sh -c \"cd fluxion && ./fluxion.sh\"'" >> ~/.bashrc
source ~/.bashrc
```

Then simply run: `fluxion`

---

## 🛠️ What Gets Installed

### Termux Packages
- Git, Wget, Curl
- Proot (for Ubuntu environment)
- Python 2 & 3 (optional)
- Figlet (for banners)

### Ubuntu Environment
- Wireless Tools (aircrack-ng, hostapd, etc.)
- Network utilities (iptables, dsniff)
- Fluxion framework
- Optional: reaver, bully, pixiewps, hashcat

---

## 🐛 Troubleshooting

### Common Issues

**Storage permission denied**
```bash
termux-setup-storage
# Manually grant permission in Android settings if needed
```

**Installation fails**
```bash
# Clear cache and retry
apt clean
pkg update
./fluxer.sh
```

**Ubuntu environment won't start**
```bash
# Reinstall proot
pkg reinstall proot
```

**Fluxion not found**
```bash
# Verify installation
ls ~/fluxion
# If missing, reinstall
rm -rf ~/fluxion
./fluxer.sh
```

---

## 📊 Stargazers Over Time

[![Stargazers over time](https://starchart.cc/0n1cOn3/FluxER.svg?variant=adaptive)](https://starchart.cc/0n1cOn3/FluxER)

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 👥 Credits

- **Original Script**: MrBlackX/TheMasterCH
- **Current Maintainer**: [0n1cOn3](https://github.com/0n1cOn3)
- **Fluxion**: [FluxionNetwork](https://github.com/FluxionNetwork/fluxion)
- **Ubuntu Script**: [tuanpham-dev](https://github.com/tuanpham-dev/termux-ubuntu)

---

## 📜 License

This project is licensed under the GNU General Public License v3.0 - see the [LICENSE](LICENSE) file for details.

---

## ⚠️ Legal Disclaimer

<div align="center">

### 🔴 FOR EDUCATIONAL PURPOSES ONLY 🔴

</div>

**Important Legal Notice:**

- This tool is provided **strictly for educational and authorized security testing purposes**
- Unauthorized access to computer networks is **illegal** under laws including:
  - Computer Fraud and Abuse Act (CFAA) - United States
  - Computer Misuse Act - United Kingdom  
  - Similar legislation in other jurisdictions
- You **must have explicit written permission** from network owners before testing
- The authors and contributors assume **NO LIABILITY** for misuse or damage
- By using this software, you agree to use it **legally and ethically**

**Users are solely responsible for compliance with all applicable local, state, federal, and international laws.**

---

<div align="center">

### 🛡️ Use Responsibly. Test Ethically. Stay Legal.

**If you don't have permission, don't do it.**

</div>

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/0n1cOn3/FluxER/issues)

---

<div align="center">

Made with ❤️ for the security research community

**Star ⭐ this repository if you find it helpful!**

</div>
