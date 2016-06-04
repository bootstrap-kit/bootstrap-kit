{CompositeDisposable} = require './event-kit'
WebComponent = require './web-component'

module.exports =
class PaneView
  setModel: (@model) ->
    @subscription ?= new CompositeDisposable()

    @subscription.add @model.onDidActivateItem ({item}) =>
      itemView = WebComponent.getView(item)
      target   = WebComponent.getView(@model)
      console.log target
      console.log this

      if target.hasChildNodes()
        target.replaceChild(itemView, target.childNodes[0])
      else
        target.appendChild(itemView)
