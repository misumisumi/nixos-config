{ pkgs, wm, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./network.nix
    ./gpu.nix
    ../common/pulseaudio.nix
    ../common/printer.nix
    ../../apps/desktop/wm/${wm}/xserver.nix
  ] ++
  (import ../../apps/common/virtualisation);
  
  nix = {
    extraOptions = ''
      binary-caches-parallel-connections = 24
    '';
  };
}
