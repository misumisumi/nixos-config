{
  systemPkgs = pkgs:
    with pkgs; [
      coreutils-full # GNU coreutils
      neovim # Editor
      git # Version control system
      killall # Process killer
      pciutils # Device utils
      usbutils
      screen # Separate terminal
      wget # Downloader
      curl
      traceroute # Track the network route
      gptfdisk # GPT partition tools
    ];
}
