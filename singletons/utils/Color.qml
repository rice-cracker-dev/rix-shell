pragma Singleton
import Quickshell
import QtQuick

Singleton {
  function colorA(color, opacity) {
    return Qt.rgba(color.r, color.g, color.b, opacity);
  }
}
