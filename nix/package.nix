# yoinked from https://github.com/Rexcrazy804/Zaphkiel/blob/master/users/Wrappers/quickshell.nix
{
  makeBinPath,
  symlinkJoin,
  makeWrapper,
  quickshell,
  makeFontsConf,
  lib,
  configDir,
  qtDeps ? [],
  fonts ? [],
  extraPackages ? [],
}: let
  inherit (import ./lib.nix lib) mkQmlPath;
in
  symlinkJoin rec {
    name = "qs-wrapper";
    paths = [quickshell];

    buildInputs = [makeWrapper];

    qmlPath = mkQmlPath qtDeps;

    fontconfig = makeFontsConf {
      fontDirectories = fonts;
    };

    binPath = makeBinPath extraPackages;

    postBuild = ''
      wrapProgram $out/bin/quickshell \
        --set FONTCONFIG_FILE "${fontconfig}" \
        --set QML2_IMPORT_PATH "${qmlPath}" \
        --set PATH "${binPath}" \
        --add-flags '-p ${configDir}'
    '';

    meta.mainProgram = "quickshell";
  }
