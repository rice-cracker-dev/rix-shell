import QtQuick
import "../.."

BarPanelItem {
  id: root

  Item {
    anchors {
      fill: root
      margins: 8
    }

    NotificationArea {
      anchors {
        top: parent.top
        bottom: parent.bottom
        left: parent.left
        right: parent.right
      }
    }
  }
}
