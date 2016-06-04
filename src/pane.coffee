WebComponent = require './web-component'
PaneItem     = require './pane-item'
PaneView     = require './pane-view'
{copyProperties} = require './util'

# Public: Provide a pane to multiple items
#
module.exports =
class Pane extends WebComponent
  constructor: (args...) ->
    super args...
    @activeItem = null
    @options.autoAttachComponents = false

    @subscription.add @observeComponents (component) =>
      # PaneItemize component
      copyProperties PaneItem::, component

      unless @activeItem?
        @activateItem(component)

    if @options.view
      # view has been already created.  Check if setModel is defined
      view = WebComponent.getView(this)

      unless view.setModel?
        view.setModel = PaneView::setModel
        view.setModel(this)

  # Public: Activate given component
  #
  # * `component` {WebComponent} to be activated
  #
  # Returns the previously activated {WebComponent}
  activateItem: (component) ->
    current = @activeItem
    @activeItem = component

    @emitter.emit 'did-active-item-change', {oldItem: current, newItem: @activeItem}
    @emitter.emit 'did-activate-item', {item: component}
    @emitter.emit 'did-deactivate-item', {item: current}

    component.emitter.emit 'did-activate'

    if current?
      current.emitter.emit 'did-deactivate'

    current

  # Public: Invoke given callback if item has been activated
  #
  # * `callback` {Function} to be called if item has been activated
  #   * `info` {Object} with following keys
  #     * `item` {WebComponent} which is activated
  #
  # Returns a {Disposable} on which `.dispose()` can be called to unsubscribe.
  onDidActivateItem: (callback) ->
    @emitter.on 'did-activate-item', callback

  # Public: Invoke given callback if active item has been changed
  #
  # * `callback` {Function} to be called if item has been changed
  #   * `info` {Object} with following keys
  #     * `oldItem` {WebComponent} which was activated
  #     * `newItem` {WebComponent} which is activated
  #
  # Returns a {Disposable} on which `.dispose()` can be called to unsubscribe.
  onDidActiveItemChange: (callback) ->
    @emitter.on 'did-activate-item-change', callback

  # Public: Invoke given callback if item has been deactivated
  #
  # * `callback` {Function} to be called if item has been deactivated
  #   * `info` {Object} with following keys
  #     * `item` {WebComponent} which is activated
  #
  # Returns a {Disposable} on which `.dispose()` can be called to unsubscribe.
  onDidDeactivateItem: (callback) ->
    @emitter.on 'did-deactivate-item', callback
