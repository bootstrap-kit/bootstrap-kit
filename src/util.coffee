module.exports =
  # Public: Convert an HTML string to an element
  #
  # * `string` {String} to be converted
  # * `tagName` optional {String} to pass an element name other than 'div'
  #
  # If you pass a single root, you will get the element back unless you pass a
  # `tagName`.  If you pass multiple roots, e.g. some paragraphs, you get back
  # a `div` element containg the paragraphs.
  #
  # Returns {HTMLElement}
  str2elem: (string, tagName) ->
    e = document.createElement(tagName ? 'div')
    e.innerHTML = string

    unless tagName?
      if e.childNodes.length == 1
        e = e.childNodes[0]

    return e

  # Public: Add classes to an element
  #
  # * `element` {HTMLElement} add classes to
  # * `args` all other args are either class-name strings or arrays of these
  #   strings are splitted on whitespace, if any is in.
  #
  # ```coffee
  #   addClasses elem, 'foo bar', ['x', 'y z']
  # ```
  # is equivalent to
  # ```coffee
  #   elem.classList.add 'foo', 'bar', 'x', 'y', 'z'
  #
  # Returns the element.
  addClasses: (element, classlist...) ->
    for item in classlist

      if item instanceof Array
        callee element, item...
        continue

      if typeof item is 'string'
        item = item.trim().split(/\s+/g)
        element.classList.add item...

    element

  # Public: Copy own properties of one object to another
  #
  # * `source` {Object} copy properties from
  # * `dest` {Object} copy properties to
  #
  # Copy all own properties except constructor.  Existing properties are
  # overwritten.
  #
  # Returns `dest`.
  copyProperties: (source, dest) ->
    for name, value of source
      continue if name is 'constructor'
      continue unless source.hasOwnProperty name
      dest[name] = value

    dest
