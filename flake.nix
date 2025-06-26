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

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        self',
        inputs',
        pkgs,
        ...
      }: let
        inherit (import ./nix/lib.nix nixpkgs.lib) mkQmlPath;

        python = pkgs.python3.withPackages (python-pkgs:
          with python-pkgs; [
            rapidfuzz
          ]);

        quickshell = inputs'.quickshell.packages.default;
        extraPackages = with pkgs; [cava matugen networkmanager libqalculate wl-screenrec python];
        fonts = with pkgs; [inter noto-fonts];
        qtDeps = with pkgs.qt6; [
          qtbase
          qtdeclarative
          qtmultimedia
        ];
      in {
        packages = {
          default = self'.packages.rix-shell;
          rix-shell = pkgs.callPackage ./nix/package.nix {
            inherit extraPackages qtDeps fonts quickshell;
            configDir = ./.;
          };
        };

        devShells.default = pkgs.mkShell {
          packages = [quickshell] ++ extraPackages ++ qtDeps ++ fonts;

          FONTCONFIG_FILE = pkgs.makeFontsConf {
            fontDirectories = fonts;
          };

          QML2_IMPORT_PATH = mkQmlPath (qtDeps ++ [quickshell]);
        };
      };
    };
}
