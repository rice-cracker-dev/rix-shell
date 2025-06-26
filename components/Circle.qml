import QtQuick
import "root:/singletons"

Rectangle {
  property int size: 4

  color: Theme.color.on_background
  implicitWidth: size
  implicitHeight: size
  radius: size / 2
}
