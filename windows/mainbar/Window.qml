import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "root:/components"
import "root:/singletons"
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
  exclusiveZone: barWidth - window.barMargins
  color: 'transparent'
  visible: Theme.loaded

  Connections {
    target: MainbarService

    function onSelectedPanelChanged() {
      focusGrab.active = MainbarService.selectedPanel !== null;
    }
  }

  HyprlandFocusGrab {
    id: focusGrab
    windows: [window]
    active: false

    onCleared: {
      MainbarService.selectedPanel = null;
    }
  }

  mask: Region {
    item: root.selectedPanel ? root : contentArea
  }

  FocusScope {
    id: root
    anchors.fill: parent

    Keys.onEscapePressed: {
      if (MainbarService.selectedPanel !== null) {
        MainbarService.selectedPanel = null;
      }
    }

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

      onPressed: (MainbarService.selectedPanel = null)

      anchors {
        fill: parent
      }

      Rectangle {
        id: panelOverlayRect

        anchors.fill: parent
        color: "black"
        opacity: 0

        states: State {
          when: MainbarService.selectedPanel !== null
          PropertyChanges {
            panelOverlayRect.opacity: 0.25
          }
        }

        transitions: Transition {
          NumberAnimation {
            properties: "opacity"
            duration: 150
          }
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

          SpacerLayout {}

          ColumnLayout {
            spacing: 4
            Layout.alignment: Qt.AlignHCenter

            SystemTrayWidget {}

            BarIconButton {
              variant: "primary"
              iconUrl: Qt.resolvedUrl("root:/assets/icons/magnify.svg")
              active: MainbarService.selectedPanel === launcherPanel
              onClicked: MainbarService.togglePanel(launcherPanel)
            }
          }

          Circle {
            Layout.alignment: Qt.AlignHCenter
            opacity: 0.5
          }

          BarButton {
            id: mainButton
            variant: "primary"
            active: MainbarService.selectedPanel === mainPanel
            topPadding: 12
            bottomPadding: 12
            Layout.alignment: Qt.AlignHCenter

            onClicked: {
              MainbarService.togglePanel(mainPanel);
            }

            contentItem: ColumnLayout {
              id: mainItem
              spacing: 12

              Main.BarNotificationIcon {
                color: mainButton.color
                Layout.alignment: Qt.AlignHCenter
              }
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
          when: !!MainbarService.selectedPanel
          PropertyChanges {
            barPanel.width: MainbarService.selectedPanel.width
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
