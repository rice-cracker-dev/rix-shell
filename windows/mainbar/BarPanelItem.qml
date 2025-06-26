import QtQuick

Item {
  id: root

  readonly property BarPanel panel: root.parent
  readonly property bool isSelected: panel.selectedPanel === root

  enabled: isSelected
  opacity: 0
  x: 100
  clip: true
  focus: true
  anchors.fill: parent

  anchors {
    fill: root.panel
    margins: 8
  }

  states: State {
    name: "selected"
    when: root.isSelected
    PropertyChanges {
      root.opacity: 1
    }
  }

  transitions: Transition {
    NumberAnimation {
      properties: "opacity"
      duration: 150
    }
  }
}
