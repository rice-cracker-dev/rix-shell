import QtQuick
import QtQuick.Controls

Button {
  id: root
  property color backgroundColor: "transparent"
  property real backgroundOpacity: 1
  property color color: "#000000"
  property int radius: 8
  property bool active: false
  padding: 8
  hoverEnabled: true

  background: Rectangle {
    color: root.backgroundColor
    opacity: root.backgroundOpacity
    radius: root.radius
  }

  Behavior on backgroundColor {
    ColorAnimation {
      duration: 150
    }
  }

  Behavior on color {
    ColorAnimation {
      duration: 150
    }
  }
}
