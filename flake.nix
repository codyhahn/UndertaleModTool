# flake.nix
{
  description = "Nix flake for building UndertaleModTool";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        dotnet-sdk = pkgs.dotnet-sdk;
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "dotnet-project";
          version = "0.8.2.0";

          src = self;

          nativeBuildInputs = [
            dotnet-sdk
          ];

          buildPhase = ''
            dotnet publish -c Release -o $out/bin --self-contained false --no-restore # Adjust if needed
          '';
        };

        devShells.default = pkgs.mkShell {
          packages = [
            dotnet-sdk
          ];
        };
      });
}