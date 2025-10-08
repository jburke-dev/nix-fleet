#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

info() {
  echo -e "${GREEN}===>${NC} $*"
}

warn() {
  echo -e "${YELLOW}===> WARNING:${NC} $*"
}

error() {
  echo -e "${RED}===> ERROR:${NC} $*" >&2
  exit 1
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  error "This script must be run as root"
fi

# Prompt for configuration
read -rp "Enter hostname for this installation: " HOSTNAME
if [ -z "$HOSTNAME" ]; then
  error "Hostname cannot be empty"
fi

info "Available block devices:"
lsblk
echo ""

read -rp "Enter disk device (e.g., /dev/sda, /dev/nvme0n1): " DISK
if [ ! -b "$DISK" ]; then
  error "Device $DISK does not exist or is not a block device"
fi

read -rp "Enter GitHub repository (default: jburke-dev/nix-fleet): " REPO
REPO=${REPO:-jburke-dev/nix-fleet}

warn "This will DESTROY all data on $DISK!"
read -rp "Type 'yes' to continue: " CONFIRM
if [ "$CONFIRM" != "yes" ]; then
  error "Installation cancelled"
fi

# Partition the disk (UEFI/GPT layout)
info "Partitioning $DISK..."
parted -s "$DISK" -- mklabel gpt
parted -s "$DISK" -- mkpart root ext4 1GB 100%
parted -s "$DISK" -- mkpart ESP fat32 1MB 1GB
parted -s "$DISK" -- set 2 esp on

# Determine partition naming scheme
if [[ "$DISK" == *"nvme"* ]] || [[ "$DISK" == *"mmcblk"* ]]; then
  DISK_PREFIX="${DISK}p"
else
  DISK_PREFIX="$DISK"
fi

BOOT_PART="${DISK_PREFIX}2"
ROOT_PART="${DISK_PREFIX}1"

# Wait for partitions to be created
sleep 2

# Format partitions
info "Formatting partitions..."
mkfs.fat -F 32 -n BOOT "$BOOT_PART"
mkfs.ext4 -L nixos "$ROOT_PART"

# Mount filesystems
info "Mounting filesystems..."
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot

# Generate hardware configuration
info "Generating hardware configuration..."
nixos-generate-config --root /mnt

# Clone the flake
info "Cloning nix-fleet repository..."
cd /mnt
git clone "https://github.com/$REPO.git" nix-fleet
cd nix-fleet

# Create host directory
info "Creating host configuration..."
mkdir -p "hosts/$HOSTNAME"

# Generate configuration files using helper scripts
nix-fleet-output-config --hostname "$HOSTNAME"

vim -O ./hosts/"$HOSTNAME"/*

read -rp "Type 'yes' to perform installation: " CONTINUE_INSTALLATION
if [ "$CONTINUE_INSTALLATION" != "yes" ]; then
  error "Installation cancelled"
fi

git add .
nixos-install --flake ".#$HOSTNAME"
