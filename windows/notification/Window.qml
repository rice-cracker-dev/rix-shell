import Quickshell
import QtQuick
import "root:/singletons"

PanelWindow {
  implicitWidth: 400
  color: "transparent"
  exclusionMode: ExclusionMode.Normal

  anchors {
    right: true
    top: true
    bottom: true
  }

  margins {
    top: 16
    right: 16
  }

  mask: Region {
    item: popup.contentItem
  }

  NotificationPopup {
    id: popup

    implicitWidth: 400

    anchors {
      top: parent.top
    }
  }
}
