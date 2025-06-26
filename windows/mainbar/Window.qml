import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "root:/components"
import "root:/singletons"
import "root:/singletons/utils"
import "./panels/launcher" as Launcher
import "./panels/main" as Main

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
  visible: Theme.loaded
  WlrLayershell.keyboardFocus: WlrLayershell.OnDemand

  mask: Region {
    item: contentArea
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

      enabled: barPanel.selectedPanel !== null

      onPressed: {
        barPanel.selectedPanel = null;
      }

      anchors {
        fill: parent
      }

      Rectangle {
        id: panelOverlayRect
        
        anchors.fill: parent
        color: "black"
        opacity: 0

        states: State {
          when: barPanel.selectedPanel !== null
          PropertyChanges { panelOverlayRect.opacity: 0.25 }
        }

        transitions: Transition {
          NumberAnimation { properties: "opacity"; duration: 150 }
        }
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

          Circle {
            Layout.alignment: Qt.AlignHCenter
            opacity: 0.5
          }

          BarButton {
            id: mainButton
            variant: "primary"
            active: barPanel.selectedPanel === mainPanel
            padding: 8
            Layout.alignment: Qt.AlignHCenter

            onClicked: {
              barPanel.togglePanel(mainPanel);
            }

            contentItem: ColumnLayout {
              spacing: 12

              NetworkWidget {
                color: mainButton.color
                Layout.alignment: Qt.AlignHCenter
              }
              PipewireWidget {
                color: mainButton.color
                Layout.alignment: Qt.AlignHCenter
              }
              ClockWidget {
                color: mainButton.color
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

        Main.Panel {
          id: mainPanel
        }

        Launcher.Panel {
          id: launcherPanel
        }
      }
    }
  }
}
