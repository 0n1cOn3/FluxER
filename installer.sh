#!/bin/bash
# FluxER - Fluxion Easy Runner for Termux
# Created by MrBlackX/TheMasterCH
# Maintainer: 0n1cOn3
# Version: 1.0 (Termux Optimized)

set -euo pipefail

# ========================
# Configuration
# ========================
readonly SCRIPT_VERSION="1.0"
readonly SCRIPT_NAME="FluxER"
readonly FLUXION_REPO="https://github.com/FluxionNetwork/fluxion.git"
readonly DISTRO_NAME="ubuntu"  # Can be changed to debian, kali-nethunter, etc.

# FluxER metadata
readonly FLUXER_DESCRIPTION="Fluxion Easy Runner - Automated Fluxion installer for Termux"
readonly USE_PROOT_DISTRO=true  # Use official proot-distro instead of legacy scripts

# Termux-specific paths
readonly TERMUX_PREFIX="${PREFIX:-/data/data/com.termux/files/usr}"
readonly TERMUX_HOME="${HOME:-/data/data/com.termux/files/home}"

# Colors
readonly RED='\e[1;31m'
readonly GREEN='\e[1;32m'
readonly BLUE='\e[1;34m'
readonly PURPLE='\e[1;35m'
readonly YELLOW='\e[1;33m'
readonly NC='\e[0m'

# ========================
# Helper Functions
# ========================

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

log_error() {
    echo -e "${RED}[✗]${NC} $1" >&2
}

log_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_banner() {
    clear
    if command -v figlet &>/dev/null; then
        figlet -f small "FluxER"
    else
        echo "╔════════════════════════════╗"
        echo "║           FluxER           ║"
        echo "║      Fluxion Installer     ║"
        echo "╚════════════════════════════╝"
    fi
    echo -e "${BLUE}Created by: MrBlackX/TheMasterCH${NC}"
    echo -e "${PURPLE}Modified by: 0n1cOn3${NC}"
    echo -e "${GREEN}Version: ${SCRIPT_VERSION}${NC}"
    echo ""
}

check_termux() {
    if [[ ! -d "$TERMUX_PREFIX" ]]; then
        log_error "This script must be run in Termux!"
        exit 1
    fi
    
    # Check Android version
    local android_ver
    android_ver=$(getprop ro.build.version.release 2>/dev/null || echo "unknown")
    log_info "Android version: $android_ver"
}

check_storage_permission() {
    if [[ ! -d "$HOME/storage" ]]; then
        log_warning "Storage permission not granted"
        return 1
    fi
    return 0
}

is_package_installed() {
    dpkg -s "$1" &>/dev/null
}

install_package() {
    local package="$1"
    local skip_recommends="${2:-false}"
    
    if is_package_installed "$package"; then
        log_success "$package already installed"
        return 0
    fi
    
    log_info "Installing $package..."
    
    local apt_opts="-y -qq"
    [[ "$skip_recommends" == "true" ]] && apt_opts="$apt_opts --no-install-recommends"
    
    if apt install $apt_opts "$package" 2>&1 | grep -v "^debconf:"; then
        log_success "$package installed"
        return 0
    else
        log_error "Failed to install $package"
        return 1
    fi
}

confirm_action() {
    local prompt="$1"
    local default="${2:-n}"
    local response
    
    if [[ "$default" == "y" ]]; then
        echo -ne "${YELLOW}${prompt} [Y/n]:${NC} "
    else
        echo -ne "${YELLOW}${prompt} [y/N]:${NC} "
    fi
    
    read -r response
    response="${response:-$default}"
    [[ "$response" =~ ^[Yy]$ ]]
}

update_package_lists() {
    log_info "Updating package lists..."
    if apt update -qq 2>&1 | grep -E "(Err:|E:)"; then
        log_error "Failed to update package lists"
        return 1
    fi
    log_success "Package lists updated"
}

check_free_space() {
    local required_mb="$1"
    local available_mb
    available_mb=$(df -m "$TERMUX_HOME" | awk 'NR==2 {print $4}')
    
    if [[ "$available_mb" -lt "$required_mb" ]]; then
        log_error "Insufficient space: ${available_mb}MB available, ${required_mb}MB required"
        return 1
    fi
    log_info "Available space: ${available_mb}MB"
}

# ========================
# Main Functions
# ========================

prepare_termux_environment() {
    print_banner
    echo -e "${PURPLE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}Stage 1: Preparing Termux Environment${NC}"
    echo -e "${PURPLE}════════════════════════════════════════${NC}"
    echo ""
    
    # Check free space (at least 500MB)
    check_free_space 500 || exit 1
    
    # Setup storage permissions
    if ! check_storage_permission; then
        log_info "Requesting storage permissions..."
        termux-setup-storage
        sleep 2
        
        if ! check_storage_permission; then
            log_error "Storage permission denied. Please grant permission and retry."
            exit 1
        fi
    fi
    log_success "Storage access granted"
    
    # Update repositories
    update_package_lists || exit 1
    
    # Install core packages (minimal set)
    local core_packages=(
        "figlet"
        "wget"
        "curl"
        "git"
        "proot"
        "tar"
    )
    
    log_info "Installing core packages..."
    local failed_packages=()
    
    for pkg in "${core_packages[@]}"; do
        install_package "$pkg" true || failed_packages+=("$pkg")
    done
    
    if [[ ${#failed_packages[@]} -gt 0 ]]; then
        log_warning "Failed to install: ${failed_packages[*]}"
        if ! confirm_action "Continue anyway?"; then
            exit 1
        fi
    fi
    
    # Optional: Install Python (can be large)
    if confirm_action "Install Python 2 and 3? (may take time)"; then
        install_package "python" true
        install_package "python2" true || log_warning "Python2 may not be available in your repository"
    fi
    
    log_success "Termux environment ready!"
    sleep 2
}

download_ubuntu_script() {
    print_banner
    echo -e "${PURPLE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}Stage 2: Installing proot-distro${NC}"
    echo -e "${PURPLE}════════════════════════════════════════${NC}"
    echo ""
    
    cd "$TERMUX_HOME" || exit 1
    
    if command -v proot-distro &>/dev/null; then
        log_success "proot-distro already installed"
        return 0
    fi
    
    log_info "Installing official proot-distro..."
    
    if install_package "proot-distro"; then
        log_success "proot-distro installed successfully"
    else
        log_error "Failed to install proot-distro"
        exit 1
    fi
    
    # Show available distributions
    log_info "Available distributions:"
    proot-distro list | head -10
    
    sleep 2
}

install_ubuntu_environment() {
    print_banner
    echo -e "${PURPLE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}Stage 3: Installing Ubuntu (proot-distro)${NC}"
    echo -e "${PURPLE}════════════════════════════════════════${NC}"
    echo ""
    
    cd "$TERMUX_HOME" || exit 1
    
    # Check if already installed
    if proot-distro list 2>/dev/null | grep -q "installed.*$DISTRO_NAME"; then
        log_warning "Ubuntu is already installed"
        if ! confirm_action "Reinstall Ubuntu?"; then
            log_info "Using existing Ubuntu installation"
            return 0
        fi
        log_info "Removing existing installation..."
        proot-distro remove "$DISTRO_NAME"
    fi
    
    log_info "Installing Ubuntu via proot-distro (5-10 minutes)..."
    log_warning "Do not close Termux during installation!"
    echo ""
    
    # Install with progress
    if proot-distro install "$DISTRO_NAME"; then
        log_success "Ubuntu installation completed!"
    else
        log_error "Ubuntu installation failed (exit code: $?)"
        exit 1
    fi
    
    log_success "Ubuntu environment ready"
    sleep 2
}

setup_fluxion() {
    print_banner
    echo -e "${PURPLE}════════════════════════════════════════${NC}"
    echo -e "${BLUE}Stage 4: Installing Fluxion Tools${NC}"
    echo -e "${PURPLE}════════════════════════════════════════${NC}"
    echo ""
    
    cd "$TERMUX_HOME" || exit 1
    
    # Verify proot-distro installation
    if ! proot-distro list 2>/dev/null | grep -q "installed.*$DISTRO_NAME"; then
        log_error "$DISTRO_NAME is not installed!"
        exit 1
    fi
    
    log_info "Preparing Fluxion installation script..."
    
    # Create optimized installation script for proot-distro
    cat > install_fluxion.sh << 'INSTALL_SCRIPT'
#!/bin/bash
set -e

echo "[INFO] Updating package lists..."
apt-get update -qq

echo "[INFO] Upgrading existing packages..."
apt-get upgrade -y -qq 2>&1 | grep -v "^debconf:"

echo "[INFO] Installing wireless tools and dependencies..."
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    git \
    net-tools \
    wireless-tools \
    aircrack-ng \
    isc-dhcp-server \
    hostapd \
    iptables \
    dnsmasq \
    lighttpd \
    php-cgi \
    curl \
    wget \
    unzip \
    2>&1 | grep -v "^debconf:"

echo "[INFO] Installing optional penetration testing tools..."
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    reaver \
    bully \
    pixiewps \
    hashcat \
    ettercap-text-only \
    sslstrip \
    macchanger \
    2>&1 | grep -v "^debconf:" || echo "[WARN] Some optional tools failed"

cd /root

if [ -d "fluxion" ]; then
    echo "[INFO] Updating existing Fluxion..."
    cd fluxion
    git pull -q
else
    echo "[INFO] Cloning Fluxion repository..."
    git clone -q https://github.com/FluxionNetwork/fluxion.git
    cd fluxion
fi

chmod +x fluxion.sh
echo "[SUCCESS] Fluxion installation complete!"
INSTALL_SCRIPT
    
    chmod +x install_fluxion.sh
    
    log_info "Installing tools in Ubuntu environment..."
    log_warning "This will take 10-20 minutes depending on connection"
    echo ""
    
    # Run installation in proot-distro
    if proot-distro login "$DISTRO_NAME" --shared-tmp -- bash -c "cd $TERMUX_HOME && bash install_fluxion.sh"; then
        log_success "All tools installed successfully!"
    else
        log_error "Tool installation failed"
        exit 1
    fi
    
    # Cleanup
    rm -f install_fluxion.sh
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         INSTALLATION COMPLETE! ✓       ║${NC}"
    echo -e "${GREEN}║              Fluxion Ready!            ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BLUE}To start Fluxion:${NC}"
    echo -e "  ${YELLOW}1.${NC} proot-distro login $DISTRO_NAME"
    echo -e "  ${YELLOW}2.${NC} cd fluxion"
    echo -e "  ${YELLOW}3.${NC} ./fluxion.sh"
    echo ""
    echo -e "${PURPLE}Quick start (one command):${NC}"
    echo -e "  ${YELLOW}proot-distro login $DISTRO_NAME --shared-tmp -- bash -c 'cd fluxion && ./fluxion.sh'${NC}"
    echo ""
    echo -e "${BLUE}Or create an alias in ~/.bashrc:${NC}"
    echo -e "  ${YELLOW}alias fluxion='proot-distro login $DISTRO_NAME -- bash -c \"cd fluxion && ./fluxion.sh\"'${NC}"
    echo ""
}

show_system_info() {
    log_info "System Information:"
    echo "  • Termux Prefix: $TERMUX_PREFIX"
    echo "  • Home Directory: $TERMUX_HOME"
    echo "  • Free Space: $(df -h "$TERMUX_HOME" | awk 'NR==2 {print $4}')"
    echo "  • Architecture: $(uname -m)"
    echo ""
}

# ========================
# Main Execution
# ========================

main() {
    check_termux
    print_banner
    show_system_info
    
    echo -e "${YELLOW}⚠ WARNING ⚠${NC}"
    echo "This script will:"
    echo "  • Install Ubuntu (proot) in Termux (~200-500MB)"
    echo "  • Install wireless pentesting tools"
    echo "  • Require storage permissions"
    echo "  • Take 15-30 minutes to complete"
    echo ""
    echo -e "${RED}Note: Root access is NOT required${NC}"
    echo -e "${RED}Note: Some tools may not work without proper hardware${NC}"
    echo ""
    
    if ! confirm_action "Do you want to proceed with installation?"; then
        log_info "Installation cancelled by user"
        exit 0
    fi
    
    echo ""
    prepare_termux_environment
    download_ubuntu_script
    install_ubuntu_environment
    setup_fluxion
}

# Handle script interruption
trap 'echo -e "\n${RED}Installation interrupted!${NC}"; exit 130' INT TERM

# Run main function
main "$@"
