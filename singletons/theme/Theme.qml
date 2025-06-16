pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import "../../lib/url.js" as Url

Singleton {
  id: main

  property string type: "dark"
  property url wallpaperSource: getDefaultWallpaper()
  readonly property string wallpaperPath: Url.urlToFilePath(wallpaperSource) ?? undefined
  readonly property var color: matugenProc.output?.colors[this.type]
  readonly property bool loaded: !!color

  function getDefaultWallpaper() {
    return Qt.resolvedUrl('root:/assets/wallpaper.jpg');
  }

  IpcHandler {
    target: "theme"

    function setWallpaper(path: string): void {
      main.wallpaperSource = Qt.resolvedUrl(path);
    }
  }

  Process {
    id: matugenProc
    property var output: null

    running: !!main.wallpaperPath
    command: ['matugen', 'image', main.wallpaperPath, '-j', 'hex']

    stdout: StdioCollector {
      onStreamFinished: {
        matugenProc.output = JSON.parse(this.text);
      }
    }
  }
}
