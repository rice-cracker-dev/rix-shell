import Quickshell
import QtQuick
import "root:/components"

Item {
  id: root

  implicitWidth: childrenRect.width
  implicitHeight: childrenRect.height

  SystemClock {
    id: clock
  }

  Label {
    id: hourClock
    text: Qt.formatTime(clock.date, 'HH')

    font {
      pixelSize: 14
      weight: 600
    }
  }

  Label {
    id: minuteClock
    text: Qt.formatTime(clock.date, 'mm')

    font {
      pixelSize: 14
      weight: 600
    }

    anchors {
      horizontalCenter: hourClock.horizontalCenter
      top: hourClock.bottom
      topMargin: 4
    }
  }
}
