pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick
import "root:/lib/fuzzysort-esm.mjs" as Fuzzysort
import "root:/lib/url.js" as Url

Singleton {
  id: root
  property list<string> pathPrograms: []
  property list<var> emojiResult: []
  readonly property bool loaded: emojiSearchProcess.initialized
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
      threshold: 0.5,
      all: true
    }).map(item => item.obj);

    return result;
  }

  function beginEmojiSearch(query: string): void {
    if (root.loaded) {
      emojiSearchProcess.write(`${query}\n`);
    }
  }

  Process {
    id: emojiSearchProcess
    property bool initialized: false

    running: true
    stdinEnabled: true
    command: ["python", Url.urlToFilePath(Qt.resolvedUrl("root:/scripts/search_emoji.py"))]

    stdout: SplitParser {
      onRead: line => {
        const json = JSON.parse(line);

        if (json.type === "init") {
          emojiSearchProcess.initialized = true;
        } else if (json.type === "result") {
          root.emojiResult = json.message.map(e => {
            return {
              name: e.name,
              description: e.en_keywords.join(", "),
              section: "Emojis",
              action: () => (Quickshell.clipboardText = e.characters),
              icon: {
                text: e.characters,
                url: null,
                color: false
              }
            };
          });
        }
      }
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
