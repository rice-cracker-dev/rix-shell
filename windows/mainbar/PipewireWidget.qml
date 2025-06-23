import QtQuick
import "root:/singletons"
import "root:/components"

IconRange {
  min: 0
  max: 1
  size: 20
  value: Audio.sink?.audio?.volume || 0
  visible: Audio.sink?.ready
  color: Theme.color.on_background
  icons: Audio.sink?.audio?.muted ? ["volume-mute"] : ["volume-low", "volume-medium", "volume-high"]
}
