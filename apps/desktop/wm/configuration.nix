{ config, lib, pkgs, ... }:

{
  programs.dconf.enable = true;
  security.pam.services.login.enableGnomeKeyring = true; 
  security.pam.services.lightdm.enableGnomeKeyring = true; 
  services = {
    xserver = {
      enable = true;
      autorun = false;

      layout = "us";
      xkbOptions = "caps:control_l, super_l:alt_l, alt_l:super_l";

      libinput = {
        enable = true;
        mouse.naturalScrolling = true;
        touchpad = {
          tapping = true;
          naturalScrolling = true;
        };
      };
      displayManager = {
        lightdm = {
          enable = true;
          greeters = {
            pantheon = {
              enable = true;
            };
          };
        };
        startx = {
          enable = true;
        };
        defaultSession = "none+xsession";
        sessionCommands = ''
          ${lib.getBin pkgs.dbus}/bin/dbus-update-activation-environment --systemd --all
        '';
        session = [
          { 
            manage = "window";
            name = "xsession";
            start = ''
              ${pkgs.runtimeShell} $HOME/.xsession &
              waitPID=$!
            '';
          }
        ];
      };

      serverFlagsSection = ''
        Option "BlankTime" "0"
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime" "0"
      '';
    };
  };
  environment.systemPackages = with pkgs; [
    udevil
    xclip
    xorg.xhost
    xorg.xev
    xorg.xkill
    xorg.xrandr
    xterm
  ];
}
