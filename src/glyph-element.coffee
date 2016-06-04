{addClasses} = require './util'

class BTKGlyphElement extends HTMLSpanElement
  setModel: (@model) ->
    if cl = @model.getString()
      if m = cl.match /^(\w+)-/
        @domNode.classList.add m[1]
      @addClasses cl

    addClasses this, @model.options.class
    this

module.exports = document.registerElement 'btk-glyph',
  extends: 'i', prototype: BTKGlyphElement::
