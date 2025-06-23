pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: main
  readonly property int count: 64

  property list<real> bars: Array({
    length: count
  }).fill(0)

  Process {
    id: cavaProc
    readonly property string configPath: Qt.resolvedUrl('./cava.sh').toString().slice(7)
    readonly property int min: 0
    readonly property int max: 1000

    running: true
    command: ['bash', configPath, main.count]

    stdout: SplitParser {
      onRead: line => {
        main.bars = line.split(';').map(n => (Number(n) - cavaProc.min) / (cavaProc.max - cavaProc.min));
      }
    }
  }
}
