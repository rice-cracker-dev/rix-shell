pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
  id: main

  property string result
  property int code: -1

  Process {
    id: proc

    running: false

    stdout: SplitParser {
      onRead: data => {
        main.result = data;
      }
    }

    onExited: (exitCode, _) => {
      main.code = exitCode;
    }
  }

  function calculateExpression(expr) {
    proc.exec({
      command: ["qalc", "-t", expr]
    });
  }
}
