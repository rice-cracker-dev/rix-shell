import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "root:/components"
import "root:/singletons"
import "root:/singletons/utils"
import "./panels/launcher" as Launcher

PanelWindow {
  id: window

  property int barWidth: 48
  property double barMargins: 8

  anchors {
    top: true
    bottom: true
    right: true
  }

  screen: Quickshell.screens.values[0]
  implicitWidth: this.screen.width
  exclusionMode: ExclusionMode.Normal
  exclusiveZone: barWidth - window.barMargins
  color: 'transparent'
  visible: Theme.loaded && Launcher.SearchService.ready
  WlrLayershell.keyboardFocus: WlrLayershell.OnDemand

  mask: Region {
    item: barPanel.selectedPanel === null ? contentArea : window
  }

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

    MouseArea {
      id: panelOverlay

      visible: barPanel.selectedPanel !== null
      enabled: barPanel.selectedPanel !== null

      onPressed: {
        barPanel.selectedPanel = null;
      }

      anchors {
        left: root.left
        right: contentArea.left
        top: root.top
        bottom: root.bottom
      }

      Rectangle {
        anchors.fill: parent
        color: Qt.rgba(255, 0, 0, 0.25)
      }
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

          ColumnLayout {
            spacing: 4
            Layout.alignment: Qt.AlignHCenter

            SystemTrayWidget {}

            BarIconButton {
              variant: "primary"
              iconUrl: Qt.resolvedUrl("root:/assets/icons/magnify.svg")
              active: barPanel.selectedPanel === launcherPanel
              onClicked: barPanel.togglePanel(launcherPanel)
            }
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

      BarPanel {
        id: barPanel
        width: 0

        anchors {
          top: contentArea.top
          bottom: contentArea.bottom
          right: barRoot.left
        }

        states: State {
          when: !!barPanel.selectedPanel
          PropertyChanges {
            barPanel.width: 400
          }
        }

        Item {
          anchors {
            fill: barPanel
            margins: 8
          }

          Launcher.Panel {
            id: launcherPanel
            panel: barPanel
          }
        }
      }
    }
  }
}
