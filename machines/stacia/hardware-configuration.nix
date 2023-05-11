# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage" "uas" "sd_mod"];
      kernelModules = ["dm-snapshot"];
      luks.devices = {
        luksroot = {
          device = "/dev/disk/by-partlabel/LUKSROOT";
          preLVM = true;
          allowDiscards = true;
        };
      };
    };
    #resumeDevice = "/.swapfile";
    #kernelParams = [ "resume_offset=27234304" ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/stacia-root";
    fsType = "ext4";
  };
  fileSystems."/nix" = {
    device = "/dev/disk/by-label/stacia-nix";
    fsType = "ext4";
  };
  fileSystems."/var" = {
    device = "/dev/disk/by-label/stacia-var";
    fsType = "ext4";
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-label/stacia-home";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/st-boot";
    fsType = "vfat";
  };

  swapDevices = [
    {
      device = "/dev/mapper/VolGroupStacia-lvolswap";
      priority = 10;
    }
  ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}