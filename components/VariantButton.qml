import QtQuick
import "root:/singletons"
import "root:/singletons/utils"

Button {
  id: root
  property string variant: "surface_variant"
  property bool ghost: false
  property real variantIntensity: ghost ? -0.05 : 0.1
  readonly property var colorPair: Theme.getColorPair(variant)

  backgroundColor: ghost ? Color.colorA(Theme.color.surface_variant, 0) : colorPair[0]
  color: ghost ? Theme.color.on_background : colorPair[1]

  states: [
    State {
      when: !root.enabled
      PropertyChanges {
        root.backgroundColor: "transparent"
        root.color: root.colorPair[1]
        root.opacity: 0.5
      }
    },
    State {
      when: root.pressed || root.active
      PropertyChanges {
        root.backgroundColor: root.ghost ? colorPair[0] : Theme.getColorAlt(root.variant, root.variantIntensity * 2)
        root.color: root.ghost ? colorPair[1] : Theme.getOnColorAlt(root.variant, root.variantIntensity * 2)
      }
    },
    State {
      when: root.hovered
      PropertyChanges {
        root.backgroundColor: Theme.getColorAlt(root.ghost ? "surface_variant" : root.variant, root.variantIntensity)
        root.color: Theme.getOnColorAlt(root.ghost ? "surface_variant" : root.variant, root.variantIntensity)
      }
    }
  ]
}
