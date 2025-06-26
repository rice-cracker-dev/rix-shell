import Quickshell
import QtQuick
import QtQuick.Layouts
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

    delegate: Item {
      id: itemRoot
      required property var modelData

      implicitWidth: ListView.view.width
      implicitHeight: childrenRect.height
      clip: true

      Icon {
        id: icon

        icon: itemRoot.modelData.image
        size: 36
        colorEnabled: false
      }

      Label {
        id: summaryLabel

        text: itemRoot.modelData.summary
        font.weight: 500
        elide: Text.ElideRight

        anchors {
          leftMargin: 16
          left: icon.right
          right: itemRoot.right
        }
      }

      Label {
        text: itemRoot.modelData.body
        textFormat: Text.MarkdownText

        opacity: 0.5

        anchors {
          left: summaryLabel.left
          right: summaryLabel.right
          top: summaryLabel.bottom
          topMargin: 4
        }
      }
    }
  }
}
