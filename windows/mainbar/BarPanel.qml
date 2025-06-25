import Quickshell
import QtQuick
import "root:/singletons"

Item {
  property alias selectedPanel: persist.selectedPanel

  function togglePanel(panel: Item) {
    this.selectedPanel = this.selectedPanel === panel ? null : panel;
  }

  PersistentProperties {
    id: persist
    property Item selectedPanel
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
