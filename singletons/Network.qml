// implementation inspired from
// https://github.com/caelestia-dots/shell/blob/main/services/Network.qml
// thanks sora

pragma Singleton
import Quickshell
import Quickshell.Io
import "root:/lib/str.js" as Str

Singleton {
  id: root

  property list<var> accessPoints: []
  readonly property var activeAccessPoint: accessPoints.find(ap => ap.active)

  function isSameAccessPoint(a: var, b: var): bool {
    return a.ssid === b.ssid && a.bssid === b.bssid;
  }

  function populateAccessPoints(raw: string): void {
    const networks = raw.trim().split('\n').map(rawNetwork => {
      const [active, bssid, ssid, rate, signal, security, frequency] = Str.splitIgnoreEscaped(rawNetwork, ":");

      const network = {
        active,
        bssid,
        ssid,
        rate,
        signal,
        security,
        frequency
      };

      return network;
    }).filter(network => network.ssid.trim() !== "");

    const destroyed = accessPoints.filter(ap => !networks.find(n => isSameAccessPoint(ap, n)));
    destroyed.forEach(ap => {
      accessPoints.splice(accessPoints.indexOf(ap), 1);
    });

    networks.forEach(n => {
      const match = accessPoints.findIndex(ap => isSameAccessPoint(n, ap));
      if (match >= 0) {
        accessPoints[match] = n;
      } else {
        accessPoints.push(n);
      }
    });
  }

  Process {
    id: networkMonitorProc
    command: ["nmcli", "m"]
    running: true

    stdout: SplitParser {
      onRead: {
        networkInfoProc.running = true;
      }
    }
  }

  Process {
    id: networkInfoProc
    command: ["nmcli", "-g", "ACTIVE,BSSID,SSID,RATE,SIGNAL,SECURITY,FREQ", "d", "w"]

    stdout: StdioCollector {
      onStreamFinished: {
        root.populateAccessPoints(this.text);
      }
    }
  }
}
