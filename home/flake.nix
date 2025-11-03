{
  description = "Legacy Luminaire development environment. Provides an environment rooted at ~/ with the tools necessary to build firmware that does not specify its own environment.";

  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs?rev=4415dfb27cfecbe40a127eb3e619fd6615731004"; #This version of nixpks includes gcc-arm-embedded-12
      flake-utils.url = "github:numtide/flake-utils";
      lumi = {
        url = "git+ssh://git@bitbucket.org/luminairecoffee/lumi?rev=98e3ad280bddfe923bf1e0a6718fc7bbf47efbbf";
        flake = true;
      };
      roast = {
        url = "git+ssh://git@bitbucket.org/luminairecoffee/roast?rev=e67bb84d09c1e1d32c76b8c6cd799334eadd99c1";
        flake = true;
      };
      roast-utils = {
        url = "git+ssh://git@bitbucket.org/luminairecoffee/environment?rev=5262c706c51bcca4177ce08d307cd1f4163ce480";
        flake = true;
      };
    };

  outputs =
    { self, ... }@inputs:

    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import inputs.nixpkgs { inherit system; };
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default =
            pkgs.mkShell
              {
                packages =
                  with pkgs;
                  [
                    gcc-arm-embedded-12
                    llvmPackages_14.clangNoLibc.cc
                    inputs.lumi.packages.${system}.default
                    inputs.openocd-luminaire.packages.${system}.default
                    inputs.roast.packages.${system}.default
                    inputs.roast-utils.packages.${system}.default
                  ];
              };
        }
      );
    };
}