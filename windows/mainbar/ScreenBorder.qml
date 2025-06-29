import QtQuick
import QtQuick.Effects
import "root:/singletons"

Item {
  id: root
  required property Item item
  required property double margins

  Rectangle {
    id: base
    anchors.fill: parent
    visible: false
    color: Color.colorA(Theme.color.background, 0.8)
  }

  Item {
    id: mask
    anchors.fill: parent
    visible: false
    layer.enabled: true

    Rectangle {
      id: maskRect

      anchors {
        fill: parent
        rightMargin: item.width
        leftMargin: root.margins
        topMargin: root.margins
        bottomMargin: root.margins
      }

      radius: 16
    }
  }

  MultiEffect {
    anchors.fill: parent

    source: base
    maskEnabled: true
    maskInverted: true
    maskSource: mask
    maskThresholdMin: 0.5
    maskSpreadAtMin: 1
  }

  Rectangle {
    color: "transparent"
    radius: maskRect.radius

    border {
      color: Color.colorA(Theme.color.outline_variant, 0.50)
      width: 1
    }

    anchors {
      fill: parent

      rightMargin: item.width
      leftMargin: root.margins
      topMargin: root.margins
      bottomMargin: root.margins
    }
  }
}
