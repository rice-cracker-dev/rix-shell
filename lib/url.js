.pragma library

var urlToFilePath = (url) => {
  const str = url.toString()
  const prefix = "file://"

  if (str.startsWith(prefix)) {
    return str.slice(prefix.length)
  }

  return null
}
