import QtQuick
import QtQuick.Controls
import "root:/singletons"
import "root:/singletons/utils"

TextField {
  id: root
  property int radius: 8

  padding: 8
  color: Theme.color.on_background
  font {
    pixelSize: Theme.font.pixelSize
    family: Theme.font.family
  }

  background: Rectangle {
    color: "transparent"
    radius: root.radius

    border {
      color: Color.colorA(Theme.color.outline, 0.50)
      width: 1
    }
  }
}
