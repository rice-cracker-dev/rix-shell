import { prepare, go } from "../../../../lib/fuzzysort-esm.mjs";

let preparedEmojis = [];

WorkerScript.onMessage = ({ type, message }) => {
  if (type === "loadEmoji") {
    preparedEmojis = message.map((e) => {
      return {
        name: e.name,
        description: e.en_keywords.join(", "),
        section: "Emojis",
        action: () => (Quickshell.clipboardText = e.characters),
        icon: {
          text: e.characters,
          url: null,
          color: false,
        },
        namePrepared: prepare(e.name),
        keywordsPrepared: prepare(e.en_keywords.join()),
      };
    });
    WorkerScript.sendMessage({ type: "init", message: null });
    return;
  } else if (type == "search") {
    const result = go(message, preparedEmojis, {
      keys: ["namePrepared", "keywordsPrepared"],
      limit: 50,
      threshold: 0.5,
    }).map((item) => item.obj);

    WorkerScript.sendMessage({ type: "result", message: result });
  }
};
