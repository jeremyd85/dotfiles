# Install Windows VM

*Before you continue, remember to enable virtualization (e.g. VT-x / AMD-V) in your BIOS / UEFI settings.*

## Download

Windows 11 ISO:
https://www.microsoft.com/software-download/windows11

VirtIO Drivers ISO:
https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso

## Virtual Machine Manager

Open **Virtual Machine Manager** and click **New VM** button in the top left of the window.

Select the **Local install media (ISO image or CDROM)**. We will want to use the ISO image that we just downloaded.

Click **Browse... > Browse Local** and select the Windows ISO file from the Downloads folder.

Allocate an appropriate amount of Memory and CPU cores to be used on the VM. Keep at least 1 core and 2 GB of memory free for your host OS to run in the background
