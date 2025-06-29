import QtQuick

Item {
  id: root

  readonly property bool isSelected: MainbarService.selectedPanel === root
  default property list<QtObject> children: []

  enabled: isSelected
  z: isSelected ? 10 : 0
  opacity: 0
  x: 100
  clip: true
  focus: true
  implicitWidth: 400

  anchors {
    top: parent.top
    bottom: parent.bottom
    left: parent.left
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

  Item {
    id: wrapper

    children: root.children

    anchors {
      fill: parent
      margins: 8
    }
  }
}
