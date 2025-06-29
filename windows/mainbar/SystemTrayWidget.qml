import Quickshell
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
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
    Layout.alignment: Qt.AlignHCenter

    onClicked: event => {
      if (event.button === Qt.LeftButton) {
        modelData.activate();
      } else if (event.button === Qt.RightButton) {
        menuAnchor.open();
      } else {
        modelData.secondaryActivate();
      }
    }

    QsMenuAnchor {
      id: menuAnchor
      menu: root.modelData.menu

      anchor {
        item: root
      }
    }

    BarIconButton {
      id: button
      iconUrl: root.modelData.icon
    }
  }
}
