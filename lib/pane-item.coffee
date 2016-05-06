class PaneItem extends WebComponent
  activateItem: ->
    @container.activateItem(this)

  onDidActivate: (callback) ->
    @emitter.on 'did-activate', callback

  onDidDeactivate: (callback) ->
    @emitter.on 'did-activate', callback
