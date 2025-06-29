import QtQuick
import "root:/singletons"

Item {
  id: root
  clip: true

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
