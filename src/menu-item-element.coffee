{addClasses} = require './util'

class BTKMenuItemElement extends HTMLLIElement

  setModel: (@model) ->
    addClasses this, @model.options.class
    @innerHTML = @model.getString()

    if @model.action
      if anchor = @querySelector 'a'
        anchor.addEventListener 'click', =>
          @model.trigger()

    # @model.observeComponents (component) =>
    #   if not @classList.contains 'treeview'
    #     @classList.add 'treeview'
    #     @innerHTML += '<ul class="treeview-menu"></ul>'
    #
    #   element = @querySelector 'ul.treeview-menu'
    #   @attachComponentView element, component

    this

module.exports = document.registerElement 'btk-menu-item',
  extends: 'li', prototype: BTKMenuItemElement::
