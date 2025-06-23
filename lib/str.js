function splitIgnoreEscaped(str, sep, escape = "\\") {
  const result = [];
  let current = "";
  let escaped = false;

  for (let i = 0; i < str.length; i++) {
    const char = str[i];

    if (!escaped && char === escape) {
      escaped = true;
      continue;
    }

    if (!escaped && char === sep) {
      result.push(current);
      current = "";
    } else {
      current += char;
    }

    escaped = false;
  }

  result.push(current);

  return result;
}
