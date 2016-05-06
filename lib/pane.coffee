WebComponent = require './web-component.coffee'
PaneItem     = require './pane-item.coffee'

# Public: Provide a pane with multiple items
#
module.exports =
class Pane extends WebComponent
  constructor: (args...) ->
    super args...
    @activeItem = null

    @subscription.add @observeComponents (component, action) =>
      return if action is 'remove'

      unless @activeItem?
        @activateItem(component)

      # PaneItemize component
      for funcName in PaneItem::
        component[funcName] = PaneItem::[funcName]

  activateItem: (component) ->
    current = @activeItem
    @activeItem = component
    @emitter.emit 'did-active-item-change', {oldItem: current, newItem: @activeItem}
    @emitter.emit 'did-activate-item', {item: component}
    @emitter.emit 'did-deactivate-item', {item: current}

    component.emitter.emit 'did-activate'
    current.emitter.emit 'did-deactivate'

  onDidActivateItem: (callback) ->
    @emitter.on 'did-activate-item', callback

  onDidActiveItemChange: (callback) ->
    @emitter.on 'did-activate-item-change', callback

  onDidDeactivateItem: (callback) ->
    @emitter.on 'did-deactivate-item', callback
