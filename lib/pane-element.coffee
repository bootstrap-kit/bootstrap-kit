{CompositeDisposable} = require './event-kit.coffee'
WebComponent = require './web-component.coffee'

class PaneElement extends HTMLDivElement

  setModel: (@model) ->
    @subscription ?= new CompositeDisposable()
    @subscription.add @model.onDidActivateItem ({item}) ->
      itemView = WebComponent.getView(item)

      if @model.options.target
        target = @querySelector(@model.options.target)
      else
        target = this

      if target.hasChildNodes()
        target.replaceChild(@childNodes[0], itemView)
      else
        target.append(itemView)

module.exports = document.registerElement 'btk-pane',
  extends: 'div', prototype: PaneElement.prototype
