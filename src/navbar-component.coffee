ViewComponent = require './view-component'

module.exports =
class NavbarComponent extends ViewComponent
  createDomNode: ->
    domNode = document.createElement('nav')
    domNode.classList.add 'navbar'
    domNode
