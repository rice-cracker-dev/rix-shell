import QtQuick

Item {
  id: root
  required property BarPanel panel
  readonly property bool isSelected: panel.selectedPanel === root

  opacity: 0
  anchors.fill: parent

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
