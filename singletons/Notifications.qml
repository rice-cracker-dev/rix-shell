pragma Singleton
import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
  id: root

  readonly property alias notifications: persist.notifications
  readonly property alias popups: persist.popups
  property int defaultTimeout: 10000
  property int maxTimeout: 15000 // fuckoff flameshot

  signal notify(NotificationItem item)

  PersistentProperties {
    id: persist

    property list<NotificationItem> notifications: []
    property list<NotificationItem> popups: []
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
      const notifObject = notifComponent.createObject(root, {
        notification: notif
      });

      persist.popups.push(notifObject);
      persist.notifications.push(notifObject);
    }
  }

  Component {
    id: notifComponent

    NotificationItem {}
  }
}
