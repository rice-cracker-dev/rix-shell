import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "root:/components"
import "root:/singletons"
import "root:/singletons/utils"

ThemeLazyLoader {
  Variants {
    model: Quickshell.screens

    delegate: Component {
      PanelWindow {
        id: window
        property var modelData
        property int barWidth: 48
        property double barMargins: 8
        screen: modelData

        anchors {
          top: true
          bottom: true
          right: true
        }

        implicitWidth: modelData.width
        exclusionMode: ExclusionMode.Normal
        exclusiveZone: barWidth - window.barMargins

        mask: Region {
          item: contentArea
        }

        color: 'transparent'

        Item {
          id: root
          anchors.fill: parent

          ScreenBorder {
            id: border
            item: contentArea
            visible: false
            margins: window.barMargins
            anchors.fill: parent
          }

          MultiEffect {
            anchors.fill: parent
            source: border
            shadowEnabled: true
            shadowColor: "#000000"
          }

          Item {
            id: contentArea

            implicitWidth: barRoot.width + barPanel.width
            implicitHeight: root.height
            anchors.right: root.right

            Item {
              id: barRoot

              implicitWidth: window.barWidth
              implicitHeight: contentArea.height
              anchors.right: contentArea.right

              ColumnLayout {
                spacing: 8

                anchors {
                  fill: parent
                  topMargin: window.barMargins
                  bottomMargin: window.barMargins
                }

                MprisWidget {
                  Layout.alignment: Qt.AlignHCenter
                }

                SpacerLayout {}

                SystemTrayWidget {
                  Layout.alignment: Qt.AlignHCenter
                }

                DotSeparator {
                  Layout.alignment: Qt.AlignHCenter
                  opacity: 0.5
                }

                BarButton {
                  padding: 8
                  Layout.alignment: Qt.AlignHCenter

                  contentItem: ColumnLayout {
                    spacing: 12

                    NetworkWidget {
                      Layout.alignment: Qt.AlignHCenter
                    }
                    PipewireWidget {
                      Layout.alignment: Qt.AlignHCenter
                    }
                    ClockWidget {
                      Layout.alignment: Qt.AlignHCenter
                      Layout.topMargin: 8
                    }
                  }
                }
              }
            }

            Item {
              id: barPanel
              implicitWidth: 0
              implicitHeight: contentArea.height
              anchors.right: barRoot.left
            }
          }
        }
      }
    }
  }
}
