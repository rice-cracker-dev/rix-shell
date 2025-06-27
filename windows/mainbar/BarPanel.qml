import Quickshell
import QtQuick
import "root:/singletons"

Item {
  id: root
  property alias selectedPanel: persist.selectedPanel

  clip: true

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
