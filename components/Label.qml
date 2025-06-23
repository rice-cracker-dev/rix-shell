import QtQuick
import "../singletons"

Text {
  color: Theme.color.on_background

  font {
    pixelSize: 14
    family: "Inter Variable"
  }

  Behavior on color {
    ColorAnimation {
      duration: 150
    }
  }
}
