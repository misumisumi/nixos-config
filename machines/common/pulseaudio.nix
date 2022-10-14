{ pkgs, ... }:

{
  nixpkgs.config.pulseaudio = true;             # 一部パッケージのビルド時にpulseaudioを使うように指示する
  sound.enable = true;
  hardware = {
    pulseaudio = {
      enable = true;
      # support32Bit = true; # For 32bit apps
      package = pkgs.pulseaudioFull;            # Enable extra codecs (AAC, APTX, APTX-HD and LDAC.)
      extraConfig = ''
        load-module module-dbus-protocol
        load-module module-native-protocol-unix
        # For container
        load-module module-native-protocol-unix auth-anonymous=1 socket=/run/user/1000/pulse/pulpul
      '';
    };
  };
}
