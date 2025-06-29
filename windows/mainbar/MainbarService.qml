pragma Singleton
import Quickshell
import QtQuick

Singleton {
  property alias selectedPanel: persist.selectedPanel

  PersistentProperties {
    id: persist

    property BarPanelItem selectedPanel: null
  }

  function togglePanel(panel: Item) {
    persist.selectedPanel = persist.selectedPanel === panel ? null : panel;
  }
}
