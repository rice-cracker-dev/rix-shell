import Quickshell.Services.Notifications
import QtQuick

QtObject {
  id: root

  required property Notification notification
  property bool popup: true
  property int id: notification?.id ?? 0
  property string appName: notification?.appName ?? ""
  property string appIcon: notification?.appIcon ?? ""
  property string image: notification?.image ?? ""
  property string summary: notification?.summary ?? ""
  property string body: notification?.body ?? ""
  property list<NotificationAction> actions: notification?.actions ?? []
  property int urgency: notification?.urgency ?? NotificationUrgency.Normal

  property Timer timer: Timer {
    running: true
    interval: Math.min(Notifications.maxTimeout, root.notification?.expireTimeout > 0 ? root.notification?.expireTimeout * 1000 : Notifications.defaultTimeout)

    onTriggered: {
      Notifications.popups.splice(Notifications.popups.indexOf(root), 1);
    }
  }

  property Connections connections: Connections {
    target: root.notification

    function onClosed() {
      Notifications.notifications.splice(Notifications.notifications.indexOf(root), 1);
      Notifications.popups.splice(Notifications.popups.indexOf(root), 1);
    }
  }
}
