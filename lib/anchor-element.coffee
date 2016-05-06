ViewComponent = require('./view-component.coffee')
{addClasses} = require('./util.coffee')

# Public: Provide view for anchor WebComponent.
#
class BTKAnchorElement extends HTMLAnchorElement
  setModel: (@model) ->
    if @model.options
      @setAttribute('href', @model.options.href or '#')
      addClasses this, @model.options.class

    @innerHTML = @model.getString()
    @model.manageComponentsViews(this)
    this

module.exports = document.registerElement 'btk-a',
  extends: 'a', prototype: BTKAnchorElement::
