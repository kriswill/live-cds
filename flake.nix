{
  description = "Nix Flake for building bootable ISO images.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    flake-utils.url = "github:numtide/flake-utils";
    disko.url = "github:nix-community/disko";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, disko, ... }: with flake-utils.lib;
    eachSystem [ system.i686-linux system.x86_64-linux ] (system: {
      nixosConfigurations = {
        gnupg = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            home-manager.nixosModules.home-manager
            disko.nixosModules.disko
            ./live-cds/gnupg
          ];
        };
      };
    });
}
