ViewComponent = require './view-component.coffee'

class BTKSidebarMenuElement extends HTMLUListElement
  createdCallback: ->
    @classList.add 'sidebar-menu'

module.exports = document.registerElement 'btk-sidebar-menu',
  extends: 'ul', prototype: BTKSidebarMenuElement::
