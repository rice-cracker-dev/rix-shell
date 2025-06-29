import QtQuick
import "root:/components"

BarButton {
  id: root
  required property url iconUrl

  implicitHeight: this.implicitWidth

  contentItem: Item {
    Icon {
      anchors.centerIn: parent

      icon: root.iconUrl
      size: 16
      color: root.color
    }
  }
}
