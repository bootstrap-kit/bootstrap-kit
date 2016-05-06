ViewComponent = require './view-component.coffee'

class BTKMenuItemElement extends HTMLLIElement

  setModel: (model) ->
    addClasses this, model.options.class
    @innerHTML = @model.getString()
    @model.manageComponentsViews(this)
    this

module.exports = document.createElement 'btk-menu-item',
  extends: 'li', prototype: BTKMenuItemElement::
