{ config, hostname, ... }:
{
  services = {
    hostapd = {
      enable = false;
      radios = {
        wlp2s0 = {
          countryCode = "JP";
          band = "2g";
          networks.wlp2s0 = {
            ssid = "zephyrus";
            authentication.saePasswordsFile = [ { password = "FsP65sEZdvxMjZL"; } ]; # Use saePasswordsFile if possible.
          };
        };
      };
    };
    nscd = {
      enable = true;
    };
  };
  networking = {
    wireless = {
      enable = true;
      userControlled.enable = true;
      secretsFile = config.sops.secrets.wireless.path;
      networks = {
        "Pixel_3770" = {
          pskRaw = "ext:PIXEL";
          priority = 100;
        };
        "SHIRASAGI_PR@NHK" = {
          pskRaw = "ext:SOCIETY";
          priority = 2;
        };
        "50G_NETWORK_secure50" = {
          pskRaw = "ext:HOME";
          priority = 5;
        };
        "ASUS_RT-AC85U_5G" = {
          pskRaw = "ext:LOGGE";
          priority = 6;
        };
        "YUNET_EDU" = {
          priority = 21;
          pskRaw = "ext:YUNET";
        };
        "eduroam" = {
          priority = 20;
          auth = ''
            scan_ssid=1
            eap=PEAP
            proto=RSN
            key_mgmt=WPA-EAP
            identity="ext:EDUROAM_IDENTIFY"
            password="ext:EDUROAM_PASS"
            phase1="peaplabel=auto peap_outer_success=1"
            phase2="auth=MSCHAPV2"
          '';
        };
        "kosakaken4" = {
          pskRaw = "ext:KOSAKAKEN_NEW";
          priority = 25;
        };
        "4CE67640131C" = {
          pskRaw = "ext:KOSAKAKEN_OLD";
          priority = 24;
        };
        "kosakaken2-5G" = {
          pskRaw = "ext:KOSAKAKEN_SEMINAR";
          priority = 25;
        };
      };
    };
    hostName = "${hostname}";
    nftables.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [
        "br0"
        "incusbr0"
        "k8sbr0"
      ];
      allowedTCPPorts = [
        5353 # avahi
        4713 # PulseAudio
        1701
      ];
      allowedUDPPorts = [
        5353 # avahi
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764; # KDE-connect
        }
        {
          from = 60000;
          to = 60011; # Mosh
        }
      ];
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764; # KDE-connect
        }
        {
          from = 60000;
          to = 60011; # Mosh
        }
      ];
    };
  };

  systemd = {
    network = {
      wait-online.ignoredInterfaces = [ "wlan0" ];
      netdevs = {
        "br0".netdevConfig = {
          Kind = "bridge";
          Name = "br0";
        };
      };
      links = {
        "ethusb0" = {
          matchConfig = {
            MACAddress = "00:e0:4c:68:00:12";
          };
          linkConfig = {
            Name = "ethusb0";
          };
        };
      };
      networks = {
        "20-wired" = {
          name = "enp4s*";
          bridge = [ "br0" ];
        };
        "30-br0" = {
          name = "br0";
          DHCP = "yes";
        };
        "40-wireless" = {
          name = "wlp2s0";
          DHCP = "yes";
          address = [ "192.168.1.200" ];
        };
      };
    };
  };
}
