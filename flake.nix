{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-zoom.url = "github:nixos/nixpkgs/nixos-24.05";

    # Hotfix for https://github.com/sid115/nix-core/issues/6
    nixpkgs-gitingest.url = "github:nixos/nixpkgs/76c80aa77c543c51c78b69afe8d1367d2404b1ba";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    pre-commit-hooks.url = "github:cachix/git-hooks.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      unstable = inputs.nixpkgs-unstable;
    in
    {
      apps = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          install = {
            type = "app";
            program =
              let
                pkg = pkgs.callPackage ./apps/install { };
              in
              "${pkg}/bin/install";
            meta.description = "Install a NixOS configuration.";
          };
          create = {
            type = "app";
            program =
              let
                pkg = pkgs.callPackage ./apps/create { };
              in
              "${pkg}/bin/create";
            meta.description = "Create a new NixOS configuration.";
          };
        }
      );

      # Hotfix for https://github.com/sid115/nix-core/issues/6
      packages = forAllSystems (
        system:
        let
          basePackages = import ./pkgs unstable.legacyPackages.${system};
          additionalPackages = {
            gitingest = inputs.nixpkgs-gitingest.legacyPackages.${system}.callPackage ./pkgs/gitingest { };
          };
        in
        inputs.nixpkgs.legacyPackages.${system}.lib.attrsets.recursiveUpdate basePackages additionalPackages
      );

      overlays = import ./overlays { inherit inputs; };

      nixosModules = import ./modules/nixos;
      homeModules = import ./modules/home;

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      checks = forAllSystems (system: {
        pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt-rfc-style.enable = true;
          };
        };
      });

      templates = {
        hyprland = {
          path = ./templates/hyprland;
          description = "NixOS client configuration for Hyprland.";
        };
        server = {
          path = ./templates/server;
          description = "Minimal NixOS server configuration.";
        };
      };
    };
}
