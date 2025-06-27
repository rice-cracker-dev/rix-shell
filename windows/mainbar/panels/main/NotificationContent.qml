import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import "root:/components"
import "root:/singletons"
import "root:/singletons/utils"

WrapperRectangle {
  id: root

  required property NotificationItem modelData
  property int imageSize

  color: Color.colorA(Theme.color.surface_container, 0.5)
  radius: 16
  margin: 16

  anchors {
    bottom: root.bottom
  }

  Item {
    id: itemRoot

    implicitHeight: childrenRect.height

    Item {
      id: itemHeader

      implicitHeight: childrenRect.height

      anchors {
        left: itemRoot.left
        right: itemRoot.right
      }

      Item {
        id: itemImage

        visible: !!root.modelData.image
        implicitWidth: 48
        implicitHeight: 48
        anchors.right: itemHeader.right

        Image {
          anchors.fill: parent

          source: root.modelData.image

          sourceSize {
            width: root.imageSize
            height: root.imageSize
          }
        }
      }

      Item {
        id: labelsHeader

        implicitHeight: childrenRect.height

        anchors {
          right: itemImage.visible ? itemImage.left : itemHeader.right
          rightMargin: itemImage.visible ? 16 : 0
          left: itemHeader.left
          verticalCenter: itemImage.visible ? itemImage.verticalCenter : itemHeader.verticalCenter
        }

        Label {
          id: labelSummary
          text: root.modelData.summary
          elide: Text.ElideRight

          font {
            weight: 500
            pixelSize: 16
          }

          anchors {
            left: labelsHeader.left
            right: labelsHeader.right
            top: itemApp.bottom
            topMargin: 2
          }
        }

        Item {
          id: itemApp

          implicitHeight: childrenRect.height
          opacity: 0.5

          anchors {
            left: labelsHeader.left
            right: labelsHeader.right
          }

          Icon {
            id: iconApp

            icon: root.modelData.appIcon.trim() !== "" ? Quickshell.iconPath(root.modelData.appIcon) : Qt.resolvedUrl("root:/assets/icons/bell.svg")
            size: labelApp.height
            color: labelApp.color

            anchors {
              left: itemApp.left
              verticalCenter: itemApp.verticalCenter
            }
          }

          Label {
            id: labelApp

            text: root.modelData.appName
            elide: Text.ElideRight

            anchors {
              leftMargin: 4
              left: iconApp.right
              right: itemApp.right
              verticalCenter: itemApp.verticalCenter
            }
          }
        }
      }
    }

    Label {
      id: labelBody

      text: root.modelData.body
      textFormat: Text.RichText
      wrapMode: Text.Wrap
      elide: Text.ElideRight
      maximumLineCount: 3
      opacity: 0.75

      anchors {
        topMargin: itemImage.visible ? 8 : 0
        top: itemHeader.bottom
        left: itemRoot.left
        right: itemRoot.right
      }
    }

    Column {
      spacing: 8

      Repeater {
        model: root.modelData.actions

        delegate: VariantButton {
          id: actionButton
          required property NotificationAction modelData

          contentItem: Label {
            text: actionButton.modelData.text
          }
        }
      }
    }
  }
}
