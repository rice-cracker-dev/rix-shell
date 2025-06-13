# yoinked from https://github.com/Rexcrazy804/Zaphkiel/blob/master/users/Wrappers/quickshell.nix
{
  symlinkJoin,
  makeWrapper,
  quickshell,
  makeFontsConf,
  lib,
  configDir,
  qtDeps ? [],
  fonts ? [],
}:
symlinkJoin rec {
  name = "qs-wrapper";
  paths = [quickshell];

  buildInputs = [makeWrapper];

  qmlPath = lib.pipe qtDeps [
    (builtins.map (lib: "${lib}/lib/qt-6/qml"))
    (builtins.concatStringsSep ":")
  ];

  # requried when nix running directly
  fontconfig = makeFontsConf {
    fontDirectories = fonts;
  };

  postBuild = ''
    wrapProgram $out/bin/quickshell \
      --set FONTCONFIG_FILE "${fontconfig}" \
      --set QML2_IMPORT_PATH "${qmlPath}" \
      --add-flags '-p ${configDir}'
  '';

  meta.mainProgram = "quickshell";
}
