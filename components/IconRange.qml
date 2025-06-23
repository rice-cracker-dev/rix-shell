import QtQuick

Icon {
  required property double min
  required property double max
  required property double value
  required property var icons

  function getIndexFromValue(array, min: double, max: double, value: double): int {
    if (array.length === 0) {
      return -1;
    }

    if (min === max) {
      return 0;
    }

    const clamped = Math.max(min, Math.min(max, value));
    const t = (clamped - min) / (max - min);
    const idx = Math.round(t * (array.length - 1));

    return idx;
  }

  icon: Qt.resolvedUrl(`root:/assets/icons/${icons[getIndexFromValue(icons, min, max, value)]}.svg`)
}
