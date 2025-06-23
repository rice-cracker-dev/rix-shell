import Quickshell
import Quickshell.Wayland
import QtQuick
import "root:/singletons"

Variants {
  model: Quickshell.screens

  delegate: Component {
    PanelWindow {
      property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
        bottom: true
      }

      WlrLayershell.layer: WlrLayer.Background

      Image {
        anchors.fill: parent
        source: Theme.wallpaperSource
      }
    }
  }
}
