from sys import stdin
from json import dumps, load
from typing import TypedDict
from os.path import dirname, realpath
from rapidfuzz.process import extract

Emoji = TypedDict(
    "Emoji",
    {
        "characters": str,
        "name": str,
        "category_name": str,
        "subcategory_name": str,
        "en_keywords": list[str],
        "en_tts_description": str | None,
        "qualification": str,
    },
)

Searchable = TypedDict("Searchable", {"text": str, "emoji": Emoji, "field": str})

scriptPath = dirname(realpath(__file__))
emojis: list[Emoji] = []

with open(f"{scriptPath}/emoji.json", "r") as jsonFile:
    emojis = load(jsonFile)

# Create searchable strings for each emoji
searchable_items: list[Searchable] = []

for emoji in emojis:
    # Add the name as a searchable item
    searchable_items.append({"text": emoji["name"], "emoji": emoji, "field": "name"})

    # Add each keyword as a searchable item
    for keyword in emoji["en_keywords"]:
        searchable_items.append({"text": keyword, "emoji": emoji, "field": "keyword"})

# Extract the text for fuzzy matching
choices = [item["text"] for item in searchable_items]


def send_json_message(type: str, message: object):
    print(dumps({"type": type, "message": message}))


# too lazy to write the function myself, thanks claude
def fuzzy_search_emojis(
    query: str, limit: int = 50, score_cutoff: float = 80.0
) -> list[Emoji]:
    # Perform fuzzy matching
    matches = extract(query, choices, limit=limit, score_cutoff=score_cutoff)

    # Map results back to emoji objects
    results: list[tuple[Emoji, float, str]] = []
    seen_emojis: set[int] = set()  # To avoid duplicates

    for _, score, index in matches:
        item = searchable_items[index]
        emoji_id = id(item["emoji"])  # Use object id to avoid duplicates

        if emoji_id not in seen_emojis:
            seen_emojis.add(emoji_id)
            results.append((item["emoji"], score, item["field"]))

    return [emoji for emoji, _, _ in results]


send_json_message("init", None)
while True:
    line = input()
    send_json_message("result", fuzzy_search_emojis(line))
