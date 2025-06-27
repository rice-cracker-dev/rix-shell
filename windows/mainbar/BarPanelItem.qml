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
  implicitWidth: 400

  anchors {
    top: panel.top
    bottom: panel.bottom
    left: panel.left
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
