import Quickshell
import Quickshell.Io
import QtQuick
import "root:/components"
import "root:/singletons"
import "../.."

BarPanelItem {
  id: root
  property int radius: 16

  onIsSelectedChanged: {
    if (isSelected) {
      inputField.text = "";
      inputField.forceActiveFocus();
    }
  }

  HyprlandShortcut {
    name: "toggle_launcher"
    description: "Toggle launcher"

    onPressed: {
      root.panel.togglePanel(root);
    }
  }

  IpcHandler {
    target: "launcher"

    function open(): void {
      root.panel.selectedPanel = root;
    }

    function close(): void {
      if (root.isSelected) {
        root.panel.selectedPanel = null;
      }
    }

    function toggle(): void {
      root.panel.togglePanel(root);
    }
  }

  Item {
    id: inputItem
    implicitHeight: inputField.height

    anchors {
      left: parent.left
      right: parent.right
      bottom: parent.bottom
    }

    Icon {
      icon: Qt.resolvedUrl("root:/assets/icons/magnify.svg")
      size: 16
      color: inputField.color

      anchors {
        leftMargin: 8
        left: inputField.left
        verticalCenter: inputField.verticalCenter
      }
    }

    Input {
      id: inputField
      readonly property regexp urlRegex: new RegExp("^https?:\/\/.+$")
      readonly property bool isUrl: urlRegex.test(this.text)

      radius: root.radius
      placeholderText: "Search"
      leftPadding: 28
      Keys.forwardTo: [list]

      onAccepted: {
        if (list.currentItem) {
          list.currentItem.clicked(null);
        }
      }

      onTextChanged: {
        SearchService.beginEmojiSearch(this.text);

        if (!isUrl) {
          CalcService.calculateExpression(this.text);
        }
      }

      anchors {
        left: parent.left
        right: parent.right
      }
    }
  }

  ListView {
    id: list
    clip: true
    highlightResizeDuration: 0
    keyNavigationWraps: true
    highlightMoveDuration: 150

    anchors {
      top: parent.top
      bottom: inputItem.top
      bottomMargin: 8
      left: parent.left
      right: parent.right
    }

    model: ScriptModel {
      function optional(condition: bool, value: var): list<var> {
        return condition ? [value] : [];
      }

      values: {
        // return the full application list if no input
        if (inputField.text.trim() === "") {
          return SearchService.search("");
        }

        const openUrl = optional(inputField.isUrl, {
          name: inputField.text,
          description: "Open url",
          section: "Web",
          action: () => Quickshell.execDetached(["xdg-open", inputField.text]),
          icon: {
            text: null,
            url: Qt.resolvedUrl("root:/assets/icons/web.svg"),
            color: false
          }
        });

        const searchTheWeb = {
          name: inputField.text,
          description: "Search the web",
          section: "Web",
          action: () => Quickshell.execDetached(["xdg-open", `https://google.com/search?q=${encodeURIComponent(inputField.text)}`]),
          icon: {
            text: null,
            url: Qt.resolvedUrl("root:/assets/icons/web.svg"),
            color: false
          }
        };

        const calculation = optional(!inputField.isUrl && CalcService.code === 0 && CalcService.result.trim() !== "", {
          name: CalcService.result,
          description: "Calculation result",
          section: "Calculation",
          action: () => (Quickshell.clipboardText = CalcService.result),
          icon: {
            text: null,
            url: Qt.resolvedUrl("root:/assets/icons/calculator.svg"),
            color: false
          }
        });

        const runCommand = optional(SearchService.pathPrograms.includes(inputField.text.split(' ')[0] ?? ""), {
          name: inputField.text,
          description: "Run command",
          section: "Terminal",
          action: () => Quickshell.execDetached(["sh", "-c", inputField.text]),
          icon: {
            text: null,
            url: Qt.resolvedUrl("root:/assets/icons/console.svg"),
            color: false
          }
        });

        return [...SearchService.search(inputField.text), ...runCommand, ...SearchService.emojiResult, ...calculation, ...openUrl, searchTheWeb];
      }

      onValuesChanged: {
        list.currentIndex = 0;
      }
    }

    delegate: SearchItem {}
  }
}
