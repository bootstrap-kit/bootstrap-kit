{addClasses} = require './util.coffee'

class BTKNavbarNavElement extends HTMLUListElement

  setModel: (@model) ->
    @classList.add 'nav'
    @classList.add 'navbar-nav'
    addClasses this, @model.options.class
    this

module.exports = document.registerElement 'btk-navbar-nav',
  extends: 'ul', prototype: BTKNavbarNavElement::
