pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import "root:/lib/fuzzysort.js" as Fuzzysort
import "root:/lib/url.js" as Url

Singleton {
  id: root
  property list<string> pathPrograms: []
  property list<var> emojiResult: []
  readonly property bool ready: emojiWorker.initialized
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
        namePrepared: Fuzzysort.prepare(e.name),
        keywordsPrepared: Fuzzysort.prepare(e.keywords.join())
      };
    });

    return [...applications];
  }

  function search(query: string): var {
    const result = Fuzzysort.go(query, [...items], {
      keys: ["namePrepared", "keywordsPrepared"],
      limit: 50,
      threshold: 0.5
    }).map(item => item.obj);

    return result;
  }

  function beginEmojiSearch(query: string): void {
    emojiWorker.sendMessage({
      type: "search",
      message: query
    });
  }

  WorkerScript {
    id: emojiWorker
    property bool initialized: false
    source: Qt.resolvedUrl("./search_emoji.mjs")

    onMessage: result => {
      console.log(JSON.stringify(result));

      if (result.type === "init") {
        initialized = true;
      } else if (result.type === "result") {
        root.emojiResult = result.message;
      }
    }
  }

  FileView {
    id: jsonFile
    path: Qt.resolvedUrl('./emoji.json')
    blockLoading: true

    onLoaded: {
      emojiWorker.sendMessage({
        type: "loadEmoji",
        message: JSON.parse(this.text())
      });
    }
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
