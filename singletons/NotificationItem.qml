import Quickshell.Services.Notifications
import QtQuick

QtObject {
  id: root
  required property Notification notification
  required property list<Notification> parent

  readonly property real defaultTimeout: 5
  readonly property string appName: notification.appName
  readonly property string appIcon: notification.appIcon
  readonly property string image: notification.image
  readonly property string summary: notification.summary
  readonly property string body: notification.body
  property bool show: true

  readonly property Timer timer: Timer {
    running: true
    interval: notification.expireTimeout > 0 ? notification.expireTimeout : root.defaultTimeout
    onTriggered: {
      root.show = false;
    }
  }

  readonly property Connections connections: Connections {
    target: notif.notification.Retainable

    function onDropped(): void {
      root.parent.splice(root.list.indexOf(notif), 1);
    }

    function onAboutToDestroy(): void {
      root.destroy();
    }
  }
}
