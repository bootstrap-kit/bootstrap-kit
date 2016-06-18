# {Disposable, CompositeDisposable, Emitter} = require './event-kit'

#require 'json-editor'

require 'json-editor/dist/jsoneditor.min.js'

{Disposable, CompositeDisposable, Emitter} = require 'event-kit'
{copyProperties, str2elem} = require './util'

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

class Form extends WebComponent
addViewProvider Form, require './form-element'

makeElement = str2elem

module.exports = {
  Anchor, Glyph, Header, Navbar, NavbarNav, Pane, PaneItem, MenuItem,
  Aside, SidebarMenu, WebComponent, ViewComponent, addViewProvider,
  RestWebComponent, str2elem, makeElement,
  Emitter, Disposable, CompositeDisposable,
  Form,

  addPane: (name, pane) ->
    @panes ?= {}
    @panes[name] = pane

  getPane: (name) ->
    @panes[name]

  addTrigger: (name, trigger) ->
    @triggers ?= {}
    @triggers[name] = trigger

  getTrigger: (name) ->
    @triggers[name]

  trigger: (name) ->
    @getTrigger(name)?()

  slugify: (title) ->
    title.replace(/\W+/, '-').toLowerCase()

  # form: (name, schema) ->
  #   e = makeElement """<div id="name"></div>"""
  #   new JSONEditor e, {
  #     theme: 'bootstrap3'
  #     options: {
  #       disable_edit_json: true
  #       disable_properties: true
  #     }
  #     schema
  #   }

  }
