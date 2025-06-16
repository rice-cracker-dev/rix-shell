import Quickshell
import QtQuick
import "root:/components"

Label {
  SystemClock {
    id: clock
  }

  text: clock.date
}
