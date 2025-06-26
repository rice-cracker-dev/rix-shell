import QtQuick
import "../singletons"

Text {
  color: Theme.color.on_background

  font {
    pixelSize: Theme.font.pixelSize
    family: Theme.font.family
  }

  transitions: Transition {
    ColorAnimation {
      properties: "color"
      duration: 150
    }
  }
}
