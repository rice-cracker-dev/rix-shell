import QtQuick
import "root:/singletons"
import "root:/components"

IconRange {
  min: 0
  max: 100
  size: 16
  value: Network.activeAccessPoint?.signal ?? 0
  color: Theme.color.on_background
  icons: !!Network.activeAccessPoint ? ["wifi-strength-outline", "wifi-strength-1", "wifi-strength-2", "wifi-strength-3", "wifi-strength-4"] : ["wifi-strength-off"]
}
