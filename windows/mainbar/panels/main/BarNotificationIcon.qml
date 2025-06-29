import QtQuick
import "root:/singletons"
import "root:/components"

Item {
  id: root
  property color color: Theme.color.on_background

  implicitWidth: icon.width
  implicitHeight: icon.height

  Icon {
    id: icon

    icon: Qt.resolvedUrl("root:/assets/icons/bell.svg")
    size: 16
    color: root.color
  }

  Circle {
    color: Theme.color.primary
    size: 4
    visible: Notifications.notifications.length > 0

    anchors {
      top: icon.top
      right: icon.right
    }
  }
}
