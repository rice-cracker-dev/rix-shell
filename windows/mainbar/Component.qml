import Quickshell
import QtQuick
import QtQuick.Layouts
import "root:/components"
import "root:/singletons/theme"
import "root:/singletons/utils"

ThemeLazyLoader {
  Variants {
    model: Quickshell.screens

    delegate: Component {
      PanelWindow {
        property var modelData
        screen: modelData

        anchors {
          top: true
          left: true
          right: true
        }

        color: Color.colorA(Theme.color.background, 0.6)

        implicitHeight: 30

        RowLayout {
          anchors.fill: parent

          Item {
            Layout.fillWidth: true
          }

          ClockWidget {}
        }
      }
    }
  }
}
