import Quickshell
import QtQuick
import QtQuick.Layouts

FloatingWindow {
  id: main
  minimumSize: Qt.size(400, 400)

  Rectangle {
    anchors.fill: parent
    color: "black"

    RowLayout {
      anchors.fill: parent

      spacing: 8

      Repeater {
        model: CavaService.count

        Item {
          id: bar
          required property int modelData
          Layout.fillWidth: true
          Layout.fillHeight: true

          Rectangle {
            id: barRect

            anchors.bottom: bar.bottom

            implicitWidth: bar.width
            color: "#00ff00"
          }

          Rectangle {
            id: barHandle
            readonly property real acceleration: 1.05
            property real velocity: 1

            anchors.bottom: bar.bottom

            implicitWidth: bar.width
            implicitHeight: 1
            color: barRect.color
          }

          FrameAnimation {
            running: true
            onTriggered: {
              barRect.implicitHeight = bar.height * CavaService.bars[bar.modelData];

              if (barRect.height > barHandle.anchors.bottomMargin) {
                barHandle.anchors.bottomMargin = barRect.height;
                barHandle.velocity = 1;
              }
              barHandle.velocity *= barHandle.acceleration;
              barHandle.anchors.bottomMargin -= barHandle.velocity;
            }
          }
        }
      }
    }
  }
}
