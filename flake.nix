{
  description = "Home Manager configuration of nixos";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixvim,
      nixpkgs,
      home-manager,
      ...
    }:
    let
      # Supported platforms. build.sh picks the right one for the current
      # machine (via `nix eval --impure builtins.currentSystem`), so neither
      # the architecture nor the user is hardcoded here.
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;

      # Build a home configuration for the given system, resolving the active
      # user/home from the environment at evaluation time so the same config
      # works on any machine (requires --impure when switching).
      mkHome =
        system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {
            username = builtins.getEnv "USER";
            homeDirectory = builtins.getEnv "HOME";
          };
          modules = [
            ./home.nix
            nixvim.homeModules.nixvim
          ];
        };
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
      homeConfigurations = forAllSystems mkHome;
    };
}
