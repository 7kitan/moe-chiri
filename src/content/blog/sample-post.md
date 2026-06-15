---
title: Installing Debian Linux — A Step-by-Step Guide
pubDate: '2026-06-15'
tags: [linux, debian, tutorial]
---

So you want to install Debian Linux. This guide will walk you through downloading the installer, creating bootable media, and performing a standard installation.

## Prerequisites

- A computer with at least 2 GB RAM and 20 GB free disk space
- A USB drive (4 GB or larger) or a DVD
- A backup of any important data — installing an OS will wipe your disk

## Step 1: Download the Debian ISO

Head to [debian.org/download](https://www.debian.org/download) and grab the latest stable release. You have two options:

- **netinst (network install)** — small download (~700 MB); pulls packages from the internet during install
- **DVD image** — larger (~4 GB); includes most software offline

For most users, the netinst image is fine.

## Step 2: Create Bootable Media

### Using `dd` (macOS/Linux)

Insert your USB drive and find its device name:

```bash
lsblk  # or "diskutil list" on macOS
```

Unmount it and write the ISO:

```bash
sudo dd if=debian-12.x.x-amd64-netinst.iso of=/dev/sdX bs=4M status=progress
```

Replace `/dev/sdX` with your USB device (e.g. `/dev/sdb`, `/dev/disk2`). **Be very careful** — this will destroy all data on that device.

### Using Balena Etcher (Windows/macOS/Linux)

Download [Balena Etcher](https://www.balena.io/etcher/), select your ISO, pick your USB drive, and click **Flash**.

## Step 3: Boot from the USB

1. Restart your computer and enter the boot menu (usually F12, F2, Esc, or Del during startup).
2. Select your USB drive from the list.
3. You'll see the Debian installer menu. Choose **Graphical install** (or **Install** if you prefer text mode).

## Step 4: Walk Through the Installer

### Language, Location, Keyboard

Select your language, country, and keyboard layout. The installer will auto-detect locale settings based on your location.

### Network Configuration

If you're using the netinst image or want updates during install, plug in an Ethernet cable or connect to Wi-Fi. The installer will walk you through setting up a network interface and hostname.

### User Accounts

- **Root password** — set a strong password for the superuser account.
- **Full name & username** — a standard user account will be created for daily use.

### Disk Partitioning

Choose one of these options:

- **Guided — use entire disk** (recommended for beginners) — the installer will partition everything automatically.
- **Guided — use entire disk with LVM** — adds logical volume management for flexible resizing later.
- **Manual** — advanced users only.

If you're dual-booting with another OS, you'll need to use **Manual** partitioning and create a root partition (`/`, ext4) and optionally a swap partition.

### Software Selection

Use the spacebar to toggle selections. A reasonable starting point:

- **Debian desktop environment** — pick GNOME, KDE, Xfce, or another DE
- **GNOME** is the default and a great starting point
- **standard system utilities** — basic command-line tools

### Install the GRUB Boot Loader

The installer will detect your OS and offer to install GRUB. Accept the default location (usually `/dev/sda`). If dual-booting, GRUB will present a menu to choose between Debian and your other OS at boot.

## Step 5: First Boot

Remove the USB drive and reboot. You'll be greeted by GRUB — select the first entry and Debian will boot. Log in with the user account you created.

Run a quick update to make sure you have the latest packages:

```bash
sudo apt update && sudo apt upgrade -y
```

## Troubleshooting

| Problem | Likely Fix |
|---------|-----------|
| USB not detected in boot menu | Disable Secure Boot in BIOS/UEFI |
| No Wi-Fi after install | Install firmware: `sudo apt install firmware-iwlwifi` |
| Screen resolution is wrong | Install graphics drivers for your GPU |
| GRUB doesn't show dual-boot options | Boot Debian, run `sudo update-grub` |
