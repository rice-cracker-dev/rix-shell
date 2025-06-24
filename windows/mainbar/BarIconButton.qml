import QtQuick
import "root:/components"

BarButton {
  id: root
  required property url iconUrl

  padding: 8

  contentItem: Icon {
    icon: root.iconUrl
    size: 16
    color: root.color
  }
}
