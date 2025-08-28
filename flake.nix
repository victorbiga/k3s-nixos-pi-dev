{
  description = "NixOS Raspberry Pi configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nixos-hardware, raspberry-pi-nix, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [];
        };
        # Helper function to generate NixOS configurations for nodes
        mkNode = { nodeConfig, rpiVersion ? "rpi5" }:
          nixpkgs.lib.nixosSystem {
            system = "aarch64-linux"; # Architecture defined once
            modules = [
              raspberry-pi-nix.nixosModules.raspberry-pi
              raspberry-pi-nix.nixosModules.sd-image
              "${nixpkgs}/nixos/modules/profiles/minimal.nix"
              ./shared/config.nix
            ] ++ (if rpiVersion == "rpi4" then [
              nixos-hardware.nixosModules.raspberry-pi-4
              ./shared/rpi.nix
            ] else [
              ./shared/rpi.nix
            ]) ++ [ nodeConfig ];
          };
      in {
        # Formatter
        formatter = pkgs.nixpkgs-fmt;

        nixosConfigurations = {
          # Node configurations using the mkNode helper function
          dev = mkNode { nodeConfig = ./nodes/dev.nix; };
          dev-worker-1 = mkNode { nodeConfig = ./nodes/dev-worker-1.nix; };
          dev-worker-2 = mkNode {
            nodeConfig = ./nodes/dev-worker-2.nix;
            rpiVersion = "rpi4";
          };
          dev-worker-3 = mkNode {
            nodeConfig = ./nodes/dev-worker-3.nix;
            rpiVersion = "rpi4";
          };
    };
  };
}
