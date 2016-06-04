# {Disposable, CompositeDisposable, Emitter} = require './event-kit'
{Disposable, CompositeDisposable, Emitter} = require 'event-kit'
{copyProperties} = require './util'

# See https://coderwall.com/p/h5e9mg/mixins-in-coffeescript
unless Function::mixin
  Function::mixin = (mixin) ->
    copyProperties mixin::, @::

WebComponent  = require './web-component'
RestWebComponent  = require './rest-web-component'
ViewComponent = require './view-component'

addViewProvider = (modelClass, elementFactory) ->
  # elementFactory = require moduleFileName
  WebComponent.addViewProvider modelClass, (component) ->
    (new elementFactory).setModel(component)

class Anchor extends WebComponent
addViewProvider Anchor, require './anchor-element'

class Glyph extends WebComponent
addViewProvider Glyph, require './glyph-element'

class Header extends WebComponent
addViewProvider Header, require './header-component'

class Navbar extends WebComponent
addViewProvider Navbar, require './navbar-component'

class NavbarNav extends WebComponent
addViewProvider Navbar, require './navbar-nav-element'

Pane = require './pane'
addViewProvider Pane, require './pane-element'

PaneItem = require './pane-item'

class MenuItem extends WebComponent
addViewProvider MenuItem, require './menu-item-element'

class SidebarMenu extends WebComponent
addViewProvider SidebarMenu, require './sidebar-menu-element'

class Aside extends WebComponent
WebComponent.addViewProvider Aside, (object) ->
  (new ViewComponent object, 'aside').setModel(object)

module.exports = {
  Anchor, Glyph, Header, Navbar, NavbarNav, Pane, PaneItem, MenuItem,
  Aside, SidebarMenu, WebComponent, ViewComponent, addViewProvider,
  RestWebComponent
  }
