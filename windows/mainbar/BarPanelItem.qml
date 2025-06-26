import QtQuick

Item {
  id: root
  readonly property BarPanel panel: root.parent
  readonly property bool isSelected: panel.selectedPanel === root

  enabled: isSelected
  opacity: 0
  anchors.fill: parent

  anchors {
    fill: root.panel
    margins: 8
  }

  states: State {
    when: root.isSelected
    PropertyChanges {
      root.opacity: 1
    }
  }

  Behavior on opacity {
    NumberAnimation {
      duration: 150
    }
  }
}
