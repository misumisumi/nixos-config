{ config, lib, ... }:
{
  programs =
    let
      starshipCmd = "${config.home.profileDirectory}/bin/starship";
    in
    {
      starship = {
        enable = true;
        enableBashIntegration = false;
        enableZshIntegration = false;
        settings = lib.importTOML ./starship/starship.toml;
      };
      # "Do not activate on tty console"
      bash.initExtra = ''
        if [[ $TERM != "dumb" && $TERM != "linux" ]]; then
          eval "$(${starshipCmd} init bash --print-full-init)"
        fi
      '';
      zsh = {
        initExtra = ''
          if [[ $TERM != "dumb" && $TERM != "linux" ]]; then
            eval "$(${starshipCmd} init zsh)"
          fi
        '';
      };
    };
}
