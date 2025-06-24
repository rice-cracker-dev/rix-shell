import Quickshell
import QtQuick

Item {
  property alias selectedPanel: persist.selectedPanel

  function togglePanel(panel: Item) {
    this.selectedPanel = this.selectedPanel === panel ? null : panel;
  }

  PersistentProperties {
    id: persist
    property Item selectedPanel
  }

  Behavior on width {
    NumberAnimation {
      duration: 150
    }
  }
}
