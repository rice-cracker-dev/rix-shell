pragma Singleton
import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
  id: root

  readonly property alias notifications: persist.notifications

  PersistentProperties {
    id: persist

    property list<NotificationItem> notifications: []
  }

  NotificationServer {
    id: server

    keepOnReload: true

    onNotification: notif => {
      notif.tracked = true;
      console.log(notif.appIcon);
      persist.notifications.push(notifComponent.createObject(root, {
        notification: notif,
        parent: persist.notifications
      }));
    }
  }

  Component {
    id: notifComponent

    NotificationItem {}
  }
}
