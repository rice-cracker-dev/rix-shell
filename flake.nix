{
  description = "rix-shell";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        self',
        inputs',
        pkgs,
        ...
      }: let
        quickshell = inputs'.quickshell.packages.default;
        qtDeps = with pkgs.qt6; [qtbase qtdeclarative qtmultimedia];
        fonts = with pkgs; [noto-fonts];
      in {
        packages = {
          default = self'.packages.rix-shell;
          rix-shell = pkgs.callPackage ./nix/package.nix {
            inherit qtDeps fonts quickshell;
            configDir = ./.;
          };
        };

        devShells.default = pkgs.mkShell {
          packages = [quickshell] ++ qtDeps ++ fonts;
        };
      };
    };
}
