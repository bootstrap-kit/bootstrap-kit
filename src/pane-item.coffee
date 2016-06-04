WebComponent = require './web-component'

# Public: PaneItem mixin
#
# Methods of this class are mixed into objects, which are added to {Pane}
# objects.
module.exports =
class PaneItem extends WebComponent
  # Public: activate this item
  #
  activateItem: ->
    @container.activateItem(this)

  # Public: Invoke given callback if item has been activated
  #
  # * `callback` {Function} to be called if item has been activated
  #
  # Returns a {Disposable} on which `.dispose()` can be called to unsubscribe.
  onDidActivate: (callback) ->
    @emitter.on 'did-activate', callback

  # Public: Invoke given callback if item has been activated
  #
  # * `callback` {Function} to be called if item has been activated
  #
  # Returns a {Disposable} on which `.dispose()` can be called to unsubscribe.
  onDidDeactivate: (callback) ->
    @emitter.on 'did-deactivate', callback
