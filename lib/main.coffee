{Disposable, CompositeDisposable, Emitter} = require 'event-kit'
ViewRegistry = require('./view-registry.coffee')
WebComponent = require './web-component.coffee'
ViewComponent = require './view-component.coffee'

createElementView = (modelClass, moduleFileName) ->
  elementFactory = require moduleFileName
  WebComponent.addViewProvider modelClass, (component) ->
    (new elementFactory).setModel(component)

class Anchor extends WebComponent
createElementView Anchor, './anchor-element.coffee'

class Glyph extends WebComponent
createElementView Glyph, './glyph-element.coffee'

class Header extends WebComponent
createElementView Header, './header-component.coffee'

class Navbar extends WebComponent
createElementView Navbar, './navbar-component.coffee'

class NavbarNav extends WebComponent
createElementView Navbar, './navbar-nav-element.coffee'

class Pane extends WebComponent
createElementView Pane, './pane-element.coffee'

class MenuItem extends WebComponent
createElementView MenuItem, './menu-item-element.coffee'

class SidebarMenu extends WebComponent
createElementView SidebarMenu, './sidebar-menu-element.coffee'

class Aside extends WebComponent
WebComponent.addViewProvider Aside, (object) ->
  (new ViewComponent object, 'aside').setModel(object)

module.exports = {Anchor, Glyph, Header, Navbar, NavbarNav, Pane, MenuItem, Aside, SidebarMenu}

# Logo = require('./logo.coffee')
#
# views.addViewProvider Logo, (logo) ->
#   div = document.createElement('div')
#   div.innerHTML = """
#     <a href="#{logo.href}" class="logo">
#       <span class="logo-mini">#{logo.mini}</span>
#       <span class="logo-lg">#{logo.lg}</span>
#     </a>
#   """
#   div.firstChild
