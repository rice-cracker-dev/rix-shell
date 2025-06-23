import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import "root:/components"

ColumnLayout {
  spacing: 4

  Repeater {
    model: SystemTray.items

    delegate: MouseArea {
      id: root
      required property SystemTrayItem modelData

      implicitWidth: button.width
      implicitHeight: button.height
      acceptedButtons: Qt.LeftButton | Qt.RightButton

      onClicked: event => {
        if (event.button === Qt.LeftButton) {
          modelData.activate();
        } else {
          modelData.secondaryActivate();
        }
      }

      BarButton {
        id: button

        Layout.alignment: Qt.AlignHCenter
        padding: 8

        contentItem: Icon {
          size: 16
          color: button.color
          icon: root.modelData.icon
        }
      }
    }
  }
}
