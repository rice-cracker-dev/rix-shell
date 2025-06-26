import Quickshell
import QtQuick
import Quickshell.Hyprland
import "root:/singletons"

Item {
  id: root
  property alias selectedPanel: persist.selectedPanel

  function togglePanel(panel: Item) {
    this.selectedPanel = this.selectedPanel === panel ? null : panel;
  }

  PersistentProperties {
    id: persist
    property Item selectedPanel
  }

  HyprlandFocusGrab {
    id: focusGrab
    windows: [this.QsWindow.window]
    active: root.selectedPanel !== null
  }

  transitions: Transition {
    NumberAnimation {
      property: "width"
      duration: 300
      easing {
        type: Easing.BezierSpline
        bezierCurve: Theme.easingCurve
      }
    }
  }
}
