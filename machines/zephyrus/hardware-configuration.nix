# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =[ 
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot = {
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "uas" "sd_mod" ];
      kernelModules = [ "dm-snapshot" ];
      luks.devices = {
        luksroot = {
          device = "/dev/disk/by-partlabel/LUKSROOT";
          preLVM = true;
          allowDiscards = true;
        };
      };
    };
    kernelModules = [ "kvm-amd" ];
  };

  fileSystems."/" =
    { 
      device = "/dev/disk/by-label/root";
      fsType = "ext4";
    };

  fileSystems."/home" =
    { 
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { 
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
  # lower image_size
  systemd.tmpfiles.rules = [
    "w    /sys/power/image_size - - - - 0"
  ];
  swapDevices = [ 
    {
      device = "/.swapfile";
      size = 1024 * 16;
    }
  ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
