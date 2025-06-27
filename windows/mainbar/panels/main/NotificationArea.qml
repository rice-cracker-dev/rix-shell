import Quickshell
import QtQuick
import QtQuick.Controls
import "root:/singletons"
import "root:/components"

Item {
  id: root

  Item {
    id: notifBar
    implicitHeight: childrenRect.height

    anchors {
      top: root.top
      left: root.left
      right: root.right
    }

    Icon {
      id: notificationIcon
      icon: Qt.resolvedUrl("root:/assets/icons/bell.svg")
      size: 16
      color: notificationLabel.color
    }

    Label {
      id: notificationLabel

      text: "Notifications"

      font {
        pixelSize: 16
        weight: 500
      }

      anchors {
        leftMargin: 8
        left: notificationIcon.right
        right: parent.right
        verticalCenter: notificationIcon.verticalCenter
      }
    }
  }

  ListView {
    spacing: 8
    clip: true

    anchors {
      left: root.left
      right: root.right
      top: notifBar.bottom
      bottom: root.bottom
      topMargin: 8
    }

    model: ScriptModel {
      values: [...Notifications.notifications]
    }

    delegate: NotificationContent {
      implicitWidth: ListView.view.width
    }
  }
}
