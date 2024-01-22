{
  imports = [
    ./gpu.nix
    ./hardware-configuration.nix
    ./network.nix
    ./rootfs.nix
    ./sops.nix
    ./system.nix
    ./virtualisation.nix
    ./zfs.nix
    ../init
    ../../system
    ../../system/bluetooth
    ../../system/pipewire
    ../../system/musnix
    ../../apps/documentation
    ../../apps/nix-ld
    ../../apps/openfortivpn
    ../../apps/pkgs
    ../../apps/printer
    ../../apps/programs
    ../../apps/services
    ../../apps/sops
    ../../apps/ssh
    ../../apps/wm/qtile
  ];
}
