ViewComponent = require('./view-component')
{addClasses} = require('./util')

# Public: Provide view for anchor WebComponent.
#
class BTKAnchorElement extends HTMLAnchorElement
  setModel: (@model) ->
    if @model.options
      @setAttribute('href', @model.options.href or '#')
      addClasses this, @model.options.class

    @innerHTML = @model.getString()
    @model.manageComponentViews(this)
    this

module.exports = document.registerElement 'btk-a',
  extends: 'a', prototype: BTKAnchorElement::
