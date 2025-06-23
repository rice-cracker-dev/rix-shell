pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import "root:/lib/url.js" as Url

Singleton {
  id: main

  PersistentProperties {
    id: persist

    property string type: "dark"
    property url wallpaperSource: Qt.resolvedUrl('root:/assets/wallpaper/ba1.jpg')
  }

  readonly property alias wallpaperSource: persist.wallpaperSource
  readonly property var color: matugenProc.output?.colors[persist.type] ?? null
  readonly property bool loaded: color != null

  function getColorPair(key: string, def = ["#000000", "#ffffff"]): var {
    if (!color) {
      return def;
    }

    const background = color[key];
    const foreground = color[`on_${key}`];

    return background && foreground ? [background, foreground] : def;
  }

  function getColorAlt(key: string, intensity: real, def = ["#ffffff", "#000000"]) {
    const col = Qt.color(color ? color[key] : (persist.type == 'light' ? def[0] : def[1]));
    return Qt.hsla(col.hslHue, Math.min(col.hslSaturation, col.hslSaturation - intensity * 2.5), col.hslLightness - intensity, col.a);
  }

  function getOnColorAlt(key: string, intensity: real, def = ["#000000", "#ffffff"]) {
    return getColorAlt(`on_${key}`, intensity, def);
  }

  IpcHandler {
    target: "theme"

    function setWallpaper(path: string): void {
      persist.wallpaperSource = Qt.resolvedUrl(path);
    }
  }

  Process {
    id: matugenProc
    property var output: null
    readonly property var wallpaperPath: Url.urlToFilePath(persist.wallpaperSource)

    onWallpaperPathChanged: {
      if (wallpaperPath) {
        this.signal(15);
        this.command = ['matugen', 'image', wallpaperPath, '-j', 'hex'];
        this.running = true;
      }
    }

    stdout: StdioCollector {
      onStreamFinished: {
        matugenProc.output = JSON.parse(this.text);
      }
    }
  }
}
