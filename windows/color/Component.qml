import Quickshell
import QtQuick
import QtQuick.Layouts
import "root:/components"
import "root:/singletons/theme"

ThemeLazyLoader {
  FloatingWindow {
    color: "transparent"

    ColumnLayout {
      anchors.fill: parent
      spacing: 0

      Repeater {
        function colorsToArr(colors) {
          let arr = [];

          Object.entries(colors).filter(([name, _]) => !name.startsWith('on_')).forEach(([name, color]) => {
            arr = [...arr,
              {
                name,
                color,
                onColor: colors[`on_${name}`] ?? null
              }
            ];
          });

          return arr;
        }

        model: colorsToArr(Theme.color)

        Rectangle {
          id: colorRect
          required property var modelData

          Layout.fillWidth: true
          Layout.fillHeight: true

          color: modelData.color

          Text {
            anchors.centerIn: colorRect
            text: colorRect.modelData.name
            color: colorRect.modelData.onColor ?? '#dddddd'
          }
        }
      }
    }
  }
}
