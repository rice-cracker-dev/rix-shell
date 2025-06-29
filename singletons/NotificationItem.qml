import Quickshell.Services.Notifications
import QtQuick

QtObject {
  id: root

  property Notification notification
  property bool popup: true
  property int id: notification?.id ?? 0
  property string appName: notification?.appName ?? ""
  property string appIcon: notification?.appIcon ?? ""
  property string image: notification?.image ?? ""
  property string summary: notification?.summary ?? ""
  property string body: notification?.body ?? ""
  property list<NotificationAction> actions: notification?.actions ?? []
  property int urgency: notification?.urgency ?? NotificationUrgency.Normal
  property Timer timer
}
