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
    spacing: 16
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

    delegate: Item {
      id: itemRoot
      required property var modelData

      implicitWidth: ListView.view.width
      implicitHeight: childrenRect.height
      clip: true

      Item {
        id: image
        property int size: itemRoot.modelData.image ? 48 : 0

        visible: !!itemRoot.modelData.image
        implicitWidth: size
        implicitHeight: size

        anchors {
          top: itemRoot.top
          right: itemRoot.right
        }

        Image {
          anchors.fill: parent

          source: itemRoot.modelData.image

          sourceSize {
            width: image.width
            height: image.height
          }
        }
      }

      Item {
        id: itemApp
        implicitHeight: childrenRect.height
        opacity: 0.5

        anchors {
          bottom: labelSummary.top
          left: parent.left
          right: image.visible ? image.left : itemRoot.right
          rightMargin: image.visible ? 8 : 0
        }

        Icon {
          id: appIcon
          icon: Quickshell.iconPath(itemRoot.modelData.appIcon)
          size: !!itemRoot.modelData.appIcon ? 16 : 0
          color: appLabel.color
          anchors.left: parent.left
        }

        Label {
          id: appLabel
          text: itemRoot.modelData.appName

          anchors {
            leftMargin: !!itemRoot.modelData.appIcon ? 8 : 0
            left: appIcon.right
          }
        }
      }

      Label {
        id: labelSummary

        text: itemRoot.modelData.summary
        elide: Text.ElideRight

        font {
          weight: 500
          pixelSize: 16
        }

        anchors {
          bottom: image.visible ? image.bottom : null
          left: itemRoot.left
          right: image.visible ? image.left : itemRoot.right
          rightMargin: !!image.visible ? 8 : 0
        }
      }

      Label {
        id: labelBody

        text: itemRoot.modelData.body
        textFormat: Text.MarkdownText
        wrapMode: Text.Wrap
        opacity: 0.75

        anchors {
          topMargin: image.visible ? 8 : 0
          top: labelSummary.bottom
          left: itemRoot.left
          right: itemRoot.right
        }
      }
    }
  }
}
