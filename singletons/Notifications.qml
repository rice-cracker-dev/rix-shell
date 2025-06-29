pragma Singleton
import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
  id: root

  readonly property alias notifications: persist.notifications

  signal notify(NotificationItem item)

  PersistentProperties {
    id: persist

    property list<NotificationItem> notifications: []
  }

  NotificationServer {
    id: server

    actionIconsSupported: true
    actionsSupported: true
    bodyHyperlinksSupported: true
    bodyImagesSupported: true
    bodyMarkupSupported: true
    imageSupported: true
    persistenceSupported: true
    keepOnReload: false

    onNotification: notif => {
      notif.tracked = true;
      persist.notifications.push(notifComponent.createObject(root, {
        notification: notif
      }));
    }
  }

  Component {
    id: notifComponent

    NotificationItem {}
  }
}
