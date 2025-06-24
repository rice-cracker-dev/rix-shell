pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import "root:/lib/fuzzysort.js" as Fuzzysort
import "root:/lib/url.js" as Url

Singleton {
  id: root
  property list<string> pathPrograms: []
  readonly property var emojis: JSON.parse(jsonFile.text())
  readonly property var items: {
    const applications = DesktopEntries.applications.values.map(e => {
      return {
        name: e.name,
        description: e.comment,
        section: "Applications",
        action: () => e.execute(),
        icon: {
          text: null,
          url: Quickshell.iconPath(e.icon),
          color: true
        },
        score: 10,
        namePrepared: Fuzzysort.prepare(e.name),
        keywordsPrepared: Fuzzysort.prepare(e.keywords.join())
      };
    });

    const preparedEmojis = emojis.map(e => {
      return {
        name: e.name,
        description: e.en_keywords.join(', '),
        section: "Emojis",
        action: () => (Quickshell.clipboardText = e.characters),
        icon: {
          text: e.characters,
          url: null,
          color: false
        },
        score: 1,
        namePrepared: Fuzzysort.prepare(e.name),
        keywordsPrepared: Fuzzysort.prepare(e.en_keywords.join())
      };
    });

    return [...applications, ...preparedEmojis];
  }

  function search(query: string, extraItems = []): var {
    const result = Fuzzysort.go(query, [...items, ...extraItems], {
      keys: ["namePrepared", "keywordsPrepared"],
      limit: 50,
      threshold: 0.5,
      scoreFn: r => r.score * (r.obj.score ?? 1)
    }).map(item => item.obj);

    return result;
  }

  FileView {
    id: jsonFile
    path: Qt.resolvedUrl('./emoji.json')
    blockLoading: true
  }

  Process {
    id: programsScript
    running: true
    command: ["python", Url.urlToFilePath(Qt.resolvedUrl("root:/scripts/scan_path.py"))]

    stdout: StdioCollector {
      onStreamFinished: {
        root.pathPrograms = JSON.parse(this.text);
      }
    }
  }
}
