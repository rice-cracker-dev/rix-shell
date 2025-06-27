import Quickshell.Widgets
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Controls
import "root:/components"
import "root:/singletons"
import "root:/singletons/utils"

WrapperRectangle {
  id: root
  readonly property MprisPlayer player: Mpris.players.values[0] ?? null
  readonly property url iconSkipPrevious: Qt.resolvedUrl("root:/assets/icons/skip-previous.svg")
  readonly property url iconSkipNext: Qt.resolvedUrl("root:/assets/icons/skip-next.svg")
  readonly property url iconPause: Qt.resolvedUrl("root:/assets/icons/pause.svg")
  readonly property url iconPlay: Qt.resolvedUrl("root:/assets/icons/play.svg")
  readonly property url iconMusicNote: Qt.resolvedUrl("root:/assets/icons/music-note.svg")
  readonly property url iconMusicNoteOff: Qt.resolvedUrl("root:/assets/icons/music-note-off.svg")

  color: Color.colorA(Theme.color.surface_variant, 0)
  radius: 9999

  states: [
    State {
      when: mouseArea.containsMouse
      PropertyChanges {
        root.color: Color.colorA(Theme.getColorAlt("surface_variant", -0.05), 0.5)
      }
    }
  ]

  Behavior on color {
    ColorAnimation {
      duration: 150
    }
  }

  margin: 4

  MouseArea {
    id: mouseArea

    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height
    hoverEnabled: true

    Timer {
      running: !!root.player?.isPlaying
      interval: 1000
      triggeredOnStart: true
      repeat: true
      onTriggered: root.player?.positionChanged()
    }

    CircularProgressBar {
      id: progress

      size: 28
      lineWidth: 3
      value: root.player ? (root.player.position / root.player.length) : 0
      visible: !!root.player
    }

    Icon {
      id: noteIcon

      icon: !!root.player ? root.iconMusicNote : root.iconMusicNoteOff
      size: 16
      color: Theme.color.on_background
      anchors.centerIn: progress

      states: State {
        when: !!root.player
        PropertyChanges {
          noteIcon.size: 12
        }
      }

      Behavior on size {
        NumberAnimation {
          duration: 150
        }
      }
    }

    Item {
      id: controls
      implicitWidth: childrenRect.width
      implicitHeight: childrenRect.height
      opacity: 0
      clip: true

      anchors {
        horizontalCenter: progress.horizontalCenter
        top: progress.bottom
        topMargin: 8
      }

      transitions: Transition {
        PropertyAnimation {
          properties: "opacity"
          duration: 150
        }
      }

      states: State {
        when: mouseArea.containsMouse
        PropertyChanges {
          controls.opacity: 1
        }
      }

      BarButton {
        id: prevButton
        enabled: root.player?.canGoPrevious

        action: Action {
          onTriggered: root.player?.previous()
        }

        contentItem: Icon {
          icon: root.iconSkipPrevious
          size: 20
          color: prevButton.color
        }
      }

      BarButton {
        id: pauseButton
        anchors.top: prevButton.bottom
        enabled: root.player?.isPlaying ? root.player?.canPause : root.player?.canPlay

        action: Action {
          onTriggered: {
            root.player.isPlaying = !root.player?.isPlaying;
          }
        }

        contentItem: Icon {
          icon: root.player?.isPlaying ? root.iconPause : root.iconPlay
          size: 20
          color: pauseButton.color
        }
      }

      BarButton {
        id: nextButton
        anchors.top: pauseButton.bottom
        enabled: root.player?.canGoNext

        action: Action {
          onTriggered: root.player?.next()
        }

        contentItem: Icon {
          icon: root.iconSkipNext
          size: 20
          color: pauseButton.color
        }
      }
    }
  }
}
