import QtQuick
import "root:/singletons"

ListView {
  id: itemsRoot

  add: Transition {
    NumberAnimation {
      property: "x"
      duration: 300
      from: itemsRoot.width
      to: 0
      easing {
        type: Easing.BezierSpline
        bezierCurve: Theme.easingCurve
      }
    }
  }

  remove: Transition {
    NumberAnimation {
      property: "x"
      duration: 300
      from: 0
      to: itemsRoot.width
      easing {
        type: Easing.BezierSpline
        bezierCurve: Theme.easingCurve
      }
    }
  }

  removeDisplaced: Transition {
    NumberAnimation {
      property: "y"
      duration: 300
      easing {
        type: Easing.BezierSpline
        bezierCurve: Theme.easingCurve
      }
    }
  }

  displaced: Transition {
    NumberAnimation {
      properties: "x,y"
      duration: 300
      easing {
        type: Easing.BezierSpline
        bezierCurve: Theme.easingCurve
      }
    }
  }
}
