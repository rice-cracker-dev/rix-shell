import Quickshell
import QtQuick

ShellRoot {
  PanelWindow {
    anchors {
      top: true
      left: true
      right: true
    }

    height: 30

    Rectangle {
      anchors {
        left: parent.left
        top: parent.top
        bottom: parent.bottom
      }

      width: 100
      color: "red"

      Text {
        text: "text\ntwo line"
        color: "black"
        font.pixelSize: 16

        anchors {
          left: parent.left
          verticalCenter: parent.verticalCenter
        }
      }
    }
  }
}
