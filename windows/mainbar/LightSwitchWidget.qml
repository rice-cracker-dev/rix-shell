import QtQuick
import "root:/components"
import "root:/singletons"

BarButton {
  padding: 8
  onClicked: Theme.toggleTheme()

  contentItem: Icon {
    readonly property url iconMoon: Qt.resolvedUrl("root:/assets/icons/moon-waxing-crescent.svg")
    readonly property url iconSun: Qt.resolvedUrl("root:/assets/icons/white-balance-sunny.svg")

    icon: Theme.type === "light" ? iconSun : iconMoon
    size: 16
    color: parent.color
  }
}
