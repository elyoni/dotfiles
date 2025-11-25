#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    exit 1
}

confirm() {
    echo -e "${YELLOW}$1${NC}"
    read -p "Continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Operation cancelled by user."
        exit 0
    fi
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root (use sudo)"
    fi
}

detect_usb_devices() {
    log "Detecting USB storage devices..."

    local usb_devices=($(lsblk -o NAME,TRAN,SIZE,MODEL | grep usb | awk '{print "/dev/"$1}'))

    if [ ${#usb_devices[@]} -eq 0 ]; then
        error "No USB devices found"
    fi

    echo "Found USB devices:"
    for i in "${!usb_devices[@]}"; do
        local device="${usb_devices[$i]}"
        local info=$(lsblk -o NAME,SIZE,MODEL "$device" | tail -n +2)
        echo "  [$((i+1))] $device - $info"
    done

    echo
    read -p "Select device number (1-${#usb_devices[@]}): " device_num

    if ! [[ "$device_num" =~ ^[0-9]+$ ]] || [ "$device_num" -lt 1 ] || [ "$device_num" -gt ${#usb_devices[@]} ]; then
        error "Invalid device number"
    fi

    selected_device="${usb_devices[$((device_num-1))]}"
    log "Selected device: $selected_device"

    local device_info=$(lsblk -o NAME,SIZE,MODEL "$selected_device" | tail -n +2)
    warn "Selected device: $selected_device ($device_info)"
    warn "ALL DATA ON THIS DEVICE WILL BE DESTROYED!"
    confirm "Are you sure you want to use this device?"
}

validate_iso() {
    log "Validating ISO file..."

    if [ ! -f "$iso_file" ]; then
        error "ISO file not found: $iso_file"
    fi

    if ! file "$iso_file" | grep -q "ISO 9660"; then
        warn "File may not be a valid ISO image"
        confirm "Continue anyway?"
    fi

    local size=$(du -h "$iso_file" | cut -f1)
    log "ISO file size: $size"

    local device_size=$(lsblk -b -o SIZE -n "$selected_device" | head -1)
    local iso_size=$(stat -c%s "$iso_file")

    if [ "$iso_size" -gt "$device_size" ]; then
        error "ISO file is larger than the target device"
    fi

    log "ISO validation completed"
}

unmount_device() {
    log "Unmounting any mounted partitions on $selected_device..."

    local mounted_partitions=$(mount | grep "^$selected_device" | awk '{print $1}')

    if [ -n "$mounted_partitions" ]; then
        echo "$mounted_partitions" | while read partition; do
            log "Unmounting $partition"
            umount "$partition" || warn "Failed to unmount $partition"
        done
    else
        log "No mounted partitions found"
    fi
}

flash_iso() {
    log "Starting ISO flashing process..."

    warn "About to flash $iso_file to $selected_device"
    warn "This operation cannot be undone!"
    confirm "Proceed with flashing?"

    log "Flashing ISO to device... This may take several minutes."

    if sudo dd if="$iso_file" of="$selected_device" bs=4M status=progress conv=fsync; then
        log "ISO flashing completed successfully!"
        sync
        log "Syncing filesystem changes..."
    else
        error "Failed to flash ISO to device"
    fi
}

verify_flash() {
    log "Verifying flash operation..."

    local iso_size=$(stat -c%s "$iso_file")
    local written_size=$(dd if="$selected_device" bs=4M count=$((iso_size/4194304 + 1)) 2>/dev/null | wc -c)

    if [ "$written_size" -ge "$iso_size" ]; then
        log "Verification successful - data written to device"
    else
        warn "Verification inconclusive - please test the device manually"
    fi
}

main() {
    log "USB ISO Flasher Script"
    log "====================="

    #check_root

    if [ $# -ne 1 ]; then
        echo "Usage: $0 <iso_file>"
        echo "Example: $0 /path/to/ubuntu.iso"
        exit 1
    fi

    iso_file="$1"

    detect_usb_devices
    validate_iso
    unmount_device
    flash_iso
    verify_flash

    log "Process completed successfully!"
    log "You can now safely remove the USB device"
}

main "$@"
