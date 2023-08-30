{
  description = "Each my machine NixOS System Flake Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    lxd-nixos.url = "git+https://codeberg.org/adamcstephens/lxd-nixos";
    nur.url = "github:nix-community/NUR";
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-matlab = {
      url = "gitlab:doronbehar/nix-matlab";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    common-config.url = "github:misumisumi/nixos-common-config";
    nvimdots.url = "github:misumisumi/nvimdots";
    flakes = {
      url = "github:misumisumi/flakes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    private-config = {
      url = "git+ssh://git@github.com/misumisumi/nixos-private-config.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, ... }:
    let
      user = "sumi";
      stateVersion = "23.11"; # For Home Manager

      overlay =
        { system }:
        let
          nixpkgs-stable = import inputs.nixpkgs-stable {
            inherit system;
            config = { allowUnfree = true; };
          };
        in
        {
          nixpkgs.overlays =
            [
              inputs.nur.overlay
              inputs.nixgl.overlay
              inputs.nix-matlab.overlay
              inputs.flakes.overlays.default
              inputs.private-config.overlays.default
            ]
            ++ (import ./patches { inherit nixpkgs-stable; });
        };
    in
    {
      nixosConfigurations = (
        import ./machines {
          inherit (inputs.nixpkgs) lib;
          inherit inputs overlay stateVersion user;
        }
      );
      # homeConfigurations = (
      #   import ./hm {
      #     inherit (nixpkgs) lib;
      #     inherit inputs overlay stateVersion user;
      #     inherit nixpkgs nixpkgs-stable nur nixgl home-manager flakes nvimdots private-config;
      #   }
      # );
    };
}
