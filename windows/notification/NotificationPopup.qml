import Quickshell
import QtQuick
import "root:/singletons"
import "root:/components"
import "../mainbar" as Mainbar

TransitionListView {
  id: itemsRoot

  spacing: 8

  implicitHeight: itemsRoot.contentItem.height

  states: State {
    when: Mainbar.MainbarService.selectedPanel !== null
    PropertyChanges {
      itemsRoot.anchors.leftMargin: root.width
    }
  }

  model: ScriptModel {
    values: [...Notifications.popups].reverse()
  }

  delegate: NotificationContent {
    implicitWidth: ListView.view.width
    radius: 8
    color: Color.colorA(Theme.color.surface, 0.8)

    border {
      color: Color.colorA(Theme.color.outline_variant, 0.50)
      width: 0
    }

    PropertyAnimation on anchors.topMargin {
      from: this.height
      to: 0
    }
  }
}
