module.exports =
  str2elem: (string, tagName) ->
    e = document.createElement(tagName ? 'div')
    e.innerHTML = string

    if e.childNodes.length == 1
      e = e.childNodes[0]

    return e

  addClasses: (element, classlist...) ->
    for item in classlist

      if item instanceof Array
        callee element, item...
        continue

      if typeof item is 'string'
        item = item.trim().split(/\s+/g)
        element.classList.add item...
