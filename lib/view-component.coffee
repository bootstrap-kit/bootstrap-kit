{addClasses} = require './util.coffee'

# Public: Provide view for header WebComponent.
#
#
module.exports =
class ViewComponent

  constructor: (model, @tagName) ->
    @domNode = null
    @subscription = null
    @setModel(model)

  createDomNode: () ->
    unless @tagName?
      throw new Error "You have to implement createDomNode()"

    e = document.createElement @tagName
    e.innerHTML = @model.getString()
    e

  updateDomNode: () ->

  getDomNode: ->
    @domNode

  setModel: (@model) ->
    if @domNode?
      @updateDomNode()
    else
      @domNode = @createDomNode()

    if @model.action?
      @domNode.addEventListener 'click', @model.action

    if @model.options.class
      addClasses @domNode, @model.options.class

    @domNode.btkViewComponent = this

    @subscription?.dispose()
    @subscribe()
    @domNode

  subscribe: ->
    @subscription = new CompositeDisposable()
    @subscription.add @model.manageComponentsViews this
