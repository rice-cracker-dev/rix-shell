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

  property alias type: persist.type
  readonly property alias wallpaperSource: persist.wallpaperSource
  readonly property var color: matugenProc.output?.colors[persist.type] ?? null
  readonly property bool loaded: color != null
  readonly property QtObject font: QtObject {
    readonly property int pixelSize: 14
    readonly property string family: "Inter Variable"
  }

  function toggleTheme(): void {
    persist.type = persist.type === "light" ? "dark" : "light";
  }

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

    function toggle(): void {
      main.toggleTheme();
    }
  }

  Process {
    id: matugenProc

    // give a default colorscheme so qml doesnt scream at me
    property var output: {
      "colors": {
        "dark": {
          "background": "#121318",
          "error": "#ffb4ab",
          "error_container": "#93000a",
          "inverse_on_surface": "#303036",
          "inverse_primary": "#505b92",
          "inverse_surface": "#e3e1e9",
          "on_background": "#e3e1e9",
          "on_error": "#690005",
          "on_error_container": "#ffdad6",
          "on_primary": "#212c61",
          "on_primary_container": "#dee1ff",
          "on_primary_fixed": "#09164b",
          "on_primary_fixed_variant": "#384379",
          "on_secondary": "#2c2f42",
          "on_secondary_container": "#dfe1f9",
          "on_secondary_fixed": "#171a2c",
          "on_secondary_fixed_variant": "#434659",
          "on_surface": "#e3e1e9",
          "on_surface_variant": "#c6c5d0",
          "on_tertiary": "#44263e",
          "on_tertiary_container": "#ffd7f2",
          "on_tertiary_fixed": "#2d1228",
          "on_tertiary_fixed_variant": "#5d3c55",
          "outline": "#90909a",
          "outline_variant": "#46464f",
          "primary": "#b9c3ff",
          "primary_container": "#384379",
          "primary_fixed": "#dee1ff",
          "primary_fixed_dim": "#b9c3ff",
          "scrim": "#000000",
          "secondary": "#c3c5dd",
          "secondary_container": "#434659",
          "secondary_fixed": "#dfe1f9",
          "secondary_fixed_dim": "#c3c5dd",
          "shadow": "#000000",
          "surface": "#121318",
          "surface_bright": "#38393f",
          "surface_container": "#1f1f25",
          "surface_container_high": "#292a2f",
          "surface_container_highest": "#34343a",
          "surface_container_low": "#1b1b21",
          "surface_container_lowest": "#0d0e13",
          "surface_dim": "#121318",
          "surface_tint": "#b9c3ff",
          "surface_variant": "#46464f",
          "tertiary": "#e5bad8",
          "tertiary_container": "#5d3c55",
          "tertiary_fixed": "#ffd7f2",
          "tertiary_fixed_dim": "#e5bad8"
        },
        "light": {
          "background": "#fbf8ff",
          "error": "#ba1a1a",
          "error_container": "#ffdad6",
          "inverse_on_surface": "#f2f0f7",
          "inverse_primary": "#b9c3ff",
          "inverse_surface": "#303036",
          "on_background": "#1b1b21",
          "on_error": "#ffffff",
          "on_error_container": "#410002",
          "on_primary": "#ffffff",
          "on_primary_container": "#09164b",
          "on_primary_fixed": "#09164b",
          "on_primary_fixed_variant": "#384379",
          "on_secondary": "#ffffff",
          "on_secondary_container": "#171a2c",
          "on_secondary_fixed": "#171a2c",
          "on_secondary_fixed_variant": "#434659",
          "on_surface": "#1b1b21",
          "on_surface_variant": "#46464f",
          "on_tertiary": "#ffffff",
          "on_tertiary_container": "#2d1228",
          "on_tertiary_fixed": "#2d1228",
          "on_tertiary_fixed_variant": "#5d3c55",
          "outline": "#767680",
          "outline_variant": "#c6c5d0",
          "primary": "#505b92",
          "primary_container": "#dee1ff",
          "primary_fixed": "#dee1ff",
          "primary_fixed_dim": "#b9c3ff",
          "scrim": "#000000",
          "secondary": "#5a5d72",
          "secondary_container": "#dfe1f9",
          "secondary_fixed": "#dfe1f9",
          "secondary_fixed_dim": "#c3c5dd",
          "shadow": "#000000",
          "source_color": "#aab4f0",
          "surface": "#fbf8ff",
          "surface_bright": "#fbf8ff",
          "surface_container": "#efedf4",
          "surface_container_high": "#e9e7ef",
          "surface_container_highest": "#e3e1e9",
          "surface_container_low": "#f5f2fa",
          "surface_container_lowest": "#ffffff",
          "surface_dim": "#dbd9e0",
          "surface_tint": "#505b92",
          "surface_variant": "#e3e1ec",
          "tertiary": "#76546e",
          "tertiary_container": "#ffd7f2",
          "tertiary_fixed": "#ffd7f2",
          "tertiary_fixed_dim": "#e5bad8"
        }
      }
    }

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
