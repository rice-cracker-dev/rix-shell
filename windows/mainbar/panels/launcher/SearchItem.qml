import QtQuick
import "root:/components"
import "../.."

VariantButton {
  id: rootItem
  required property var modelData
  required property BarPanel panel

  implicitWidth: ListView.view.width
  padding: 8
  ghost: true
  active: ListView.isCurrentItem
  variant: "primary"
  transitions: []

  onClicked: {
    modelData.action();
    rootItem.panel.selectedPanel = null;
  }

  contentItem: Item {
    id: visualItem
    implicitHeight: childrenRect.height

    Icon {
      id: iconItem
      icon: Qt.resolvedUrl(rootItem.modelData.icon.url ?? "")
      size: 16
      visible: rootItem.modelData.icon.url != null
      color: nameItem.color
      colorEnabled: !rootItem.modelData.icon.color
    }

    Label {
      anchors.fill: iconItem
      text: rootItem.modelData.icon.text ?? ""
      color: nameItem.color
      font.pixelSize: iconItem.size
      visible: rootItem.modelData.icon.text != null
    }

    Label {
      id: descriptionItem

      text: rootItem.modelData.description ?? ""
      elide: Text.ElideRight
      opacity: 0.5
      color: nameItem.color

      anchors {
        leftMargin: 8
        left: nameItem.right
        right: visualItem.right
        verticalCenter: iconItem.verticalCenter
      }
    }

    Label {
      id: nameItem
      text: rootItem.modelData.name
      color: rootItem.color

      anchors {
        leftMargin: 8
        left: iconItem.right
        verticalCenter: iconItem.verticalCenter
      }
    }
  }
}
