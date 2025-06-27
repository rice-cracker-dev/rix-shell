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
      left: root.left
      right: root.right
      bottom: root.bottom
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

      focus: root.isSelected
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
      top: root.top
      bottom: inputItem.top
      bottomMargin: 8
      left: root.left
      right: root.right
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

    delegate: VariantButton {
      id: rootItem
      required property int index
      required property var modelData

      implicitWidth: ListView.view.width
      padding: 8
      ghost: true
      active: list.currentIndex === index
      variant: "primary"
      transitions: []

      onClicked: {
        modelData.action();
        root.panel.selectedPanel = null;
      }

      contentItem: Item {
        id: visualItem
        implicitHeight: childrenRect.height

        Icon {
          id: iconItem
          icon: Qt.resolvedUrl(rootItem.modelData.icon.url ?? "")
          size: 16
          visible: rootItem.modelData.icon.url != null
          color: nameItem.color
          colorEnabled: !rootItem.modelData.icon.color
        }

        Label {
          anchors.fill: iconItem
          text: rootItem.modelData.icon.text ?? ""
          color: nameItem.color
          font.pixelSize: iconItem.size
          visible: rootItem.modelData.icon.text != null
        }

        Label {
          id: descriptionItem

          text: rootItem.modelData.description ?? ""
          elide: Text.ElideRight
          opacity: 0.5
          color: nameItem.color

          anchors {
            leftMargin: 8
            left: nameItem.right
            right: visualItem.right
            verticalCenter: iconItem.verticalCenter
          }
        }

        Label {
          id: nameItem
          text: rootItem.modelData.name
          color: rootItem.color

          anchors {
            leftMargin: 8
            left: iconItem.right
            verticalCenter: iconItem.verticalCenter
          }
        }
      }
    }
  }
}
