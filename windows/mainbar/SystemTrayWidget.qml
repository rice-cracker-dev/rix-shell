import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import "root:/components"

Repeater {
    model: SystemTray.items

    delegate: MouseArea {
      id: root
      required property SystemTrayItem modelData

      implicitWidth: button.width
      implicitHeight: button.height
      acceptedButtons: Qt.LeftButton | Qt.RightButton
      Layout.alignment: Qt.AlignHCenter

      onClicked: event => {
        if (event.button === Qt.LeftButton) {
          modelData.activate();
        } else {
          modelData.secondaryActivate();
        }
      }

      BarIconButton {
        id: button
        iconUrl: root.modelData.icon
      }
    }
  }
