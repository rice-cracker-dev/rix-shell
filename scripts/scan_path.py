from os import getenv, scandir
from os.path import exists
from json import dumps

paths = getenv("PATH", "").split(":")
names: set[str] = set()

for path in paths:
    if not exists(path):
        continue

    for file in scandir(path):
        if file.is_file():
            names.add(file.name)

print(dumps(list(names)))
