lib: {
  mkQmlPath = deps:
    lib.pipe deps [
      (builtins.map (lib: "${lib}/lib/qt-6/qml"))
      (builtins.concatStringsSep ":")
    ];
}
