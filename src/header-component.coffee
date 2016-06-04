views = require('./view-registry').views
ViewComponent = require('./view-component')

# Public: Provide view for header WebComponent.
#
#
module.exports =
class BTKHeaderComponent extends ViewComponent

  createDomNode: ->
    domNode = document.createElement('header')
    domNode.classList.add('main-header')
    domNode
