import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications
import "root:/components"
import "root:/singletons"

WrapperRectangle {
  id: root

  required property NotificationItem modelData
  property Timer timer
  property int imageSize

  color: Color.colorA(Theme.color.surface_container, 0.5)
  radius: 16
  margin: 16

  states: [
    State {
      when: itemRoot.containsMouse
      PropertyChanges {
        root.color: Color.colorA(Theme.color.surface_container, 0.75)
      }
    }
  ]

  MouseArea {
    id: itemRoot

    implicitHeight: childrenRect.height
    hoverEnabled: true

    onClicked: {
      root.modelData.notification?.dismiss();
    }

    Item {
      id: itemHeader

      implicitHeight: Math.max(48, labelsHeader.height)

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

    Row {
      spacing: 8

      anchors {
        topMargin: 8
        top: labelBody.bottom
        left: itemRoot.left
        right: itemRoot.right
      }

      Repeater {
        model: root.modelData.actions

        delegate: Button {
          id: actionButton
          required property NotificationAction modelData
          backgroundOpacity: 0
          backgroundColor: Theme.color.primary
          color: Theme.color.primary

          onPressed: {
            modelData.invoke();
          }

          states: [
            State {
              when: actionButton.pressed
              PropertyChanges {
                actionButton.backgroundOpacity: 0.1
              }
            },
            State {
              when: actionButton.hovered
              PropertyChanges {
                actionButton.backgroundOpacity: 0.05
              }
            }
          ]

          contentItem: Label {
            color: actionButton.color
            text: actionButton.modelData.text
          }
        }
      }
    }
  }
}
