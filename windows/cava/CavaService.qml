pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "root:/lib"

Singleton {
  id: main
  readonly property int count: 64

  property list<real> bars: Array({
    length: count
  }).fill(0)

  Process {
    id: cavaProc
    readonly property int min: 0
    readonly property int max: 1000

    running: true
    command: ['bash', `${Quickshell.shellRoot}/windows/cava/cava.sh`, main.count]

    stdout: SplitParser {
      onRead: line => {
        main.bars = line.split(';').map(n => (Number(n) - cavaProc.min) / (cavaProc.max - cavaProc.min));
      }
    }
  }
}
