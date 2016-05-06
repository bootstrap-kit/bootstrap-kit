{Emitter}    = require './event-kit.coffee'
ViewRegistry = require './view-registry.coffee'
{str2elem}   = require './util.coffee'

views = null

initViews = ->
  views = new ViewRegistry()

  # View of a standard web component is HTML representation of its string.
  views.addViewProvider WebComponent, (object) ->
    e = str2elem(object.getString())

    if object.action
      e.addEventListener 'click', ->
        object.trigger()

    object.manageComponentsViews(e)

    e

initViews()

#
class WebComponent
  # Extended: Clear the view registry
  #
  # This is for testing pupose to clear the view between tests.
  @clearViewRegistry: ->
    initViews()

  # Public: Get the view for an object.
  #
  # Example:
  #
  #    document.querySelector('body').append WebComponent::getView(object)
  #
  @getView: (component) ->
    views.getView(component)

  # Public: Add a view provider for some model class.
  #
  # Example:
  #
  #    document.querySelector('body').append WebComponent::getView(component)
  #
  @addViewProvider: (modelClass, callback) ->
    views.addViewProvider modelClass, callback

  # Public: construct a {WebComponent}
  #
  # * `string` {String} An optional string, which can (optional) used by
  #   components for any purpose
  # * `options` {Object} (optional) options
  # * `arg` other args are passed to `.addComponents()`
  #
  # If you get a view for a plain WebComponent, the `string` is interpreted
  # as html code of the view.
  #
  # Example:
  #
  #    component = new WebComponent "<b>Hello World</b>")
  #    document.querySelector('body').append WebComponent::getView component
  #
  # Will return the `<b>` HTMLElement object.
  #
  constructor: (args...) ->
    return new WebComponent args... if this not instanceof WebComponent

    @options    = {}
    @string     = null
    @components = []
    @emitter    ?= new Emitter()
    @container  = null

    if args.length > 0
      if typeof args[0] is 'string'
        @string = args[0]
        args = args[1...]

    if args.length > 0
      if not (
          (args[0] instanceof WebComponent) or
          (args[0] instanceof Array)
        )
        @options = args[0]
        args = args[1...]

    if args.length > 0
      maybeAction = args[args.length-1]
      if maybeAction instanceof Function
        @onDidTrigger action
        args = args[0...-1]

    @addComponents args...

  # Public: Get string, which has been passed to constructor
  getString: ->
    @string or ''

  # Public: Check if component contained in component of given type
  #
  # * `component` {WebComponent} to be added
  isContainedIn: (type) ->
    component = this
    while component.container?
      if component.container instanceof type
        return true
      component = component.container
    return false

  # Public: Add a component
  #
  # * `component` {WebComponent} to be added
  addComponent: (args...) ->
    component = args[0]
    action = null

    if typeof component is 'string'
      component = new WebComponent args...
    else
      if args.length > 1
        action = args[1]

    @components.push component
    component.container = this
    @emitter.emit 'did-add-component', {parent: this, component}

    if action
      component.onDidTrigger action

    component

  # Public: get a Component
  getComponent: (index=0) ->
    @components[index]

  getComponents: ->
    @components

  getNextComponent: (component) ->
    next = @components.indexOf(component) + 1
    if next >= @components.length
      null
    else
      @components[next]

  getPrevComponent: (component) ->
    prev = @components.indexOf(component) - 1

    if index < 0
      null
    else
      @components[index]

  # Public: Add a list of components
  #
  # Any number of argumnets, either {Array} of {WebComponent} or {WebComponent}
  addComponents: (args...) ->
    for arg in args
      continue unless arg

      if arg instanceof Array
        for component in arg
          @addComponent component
      else
        @addComponent arg

  # Public: Remove a component
  #
  # * `component` {WebComponent} to be added
  removeComponent: (component) ->
    component.container = null
    @components.remove(component)
    @emitter.emit 'did-remove-component', {parent: this, component}

  onDidTrigger: (callback) ->
    @emitter.on 'did-trigger', callback

  trigger: ->
    @emitter.emit 'did-trigger', this

  # Public: Invoke the given callback if a child component is added to this component
  #
  # * `callback` {Function} to be called after adding the component
  #   * `info` {Object} with the following keys
  #     * `parent` {WebComponent} emitting component
  #     * `component` {WebComponent} component added
  #
  # Returns a {Disposable} on which `.dispose()` can be called to unsubscribe.
  onDidAddComponent: (callback) ->
    @emitter.on 'did-add-component', callback

  # Public: Invoke the given callback if a child component is removed from this component
  #
  # * `callback` {Function} to be called after removing the component
  #   * `info` {Object} with the following keys
  #     * `parent` {WebComponent} emitting component
  #     * `component` {WebComponent} component removed
  #
  # Returns a {Disposable} on which `.dispose()` can be called to unsubscribe.
  onDidRemoveComponent: (callback) ->
    @emitter.on 'did-remove-component', callback

  # Public: Invoke the given callback with all current and future child components
  #
  # * `callback(component)` {Function} to be called with current and future child componets
  #   * `component` {WebComponent}, that is present in {::getComponents} at the
  #     time of subscription or that is added at some later time.
  #
  observeComponents: (callback) ->
    for component in @getComponents()
      callback(component)

    @emitter.on 'did-add-component', ({component}) -> callback(component)

  # Public: install a event handlers for auto managing child component views
  #
  # * `element` - HTMLElement to append the views to
  #
  # This is a convenience function for observing views, adding them to given
  # view and removing it if component has been removed.
  #
  manageComponentsViews: (element) ->
    @observeComponents (component) ->
      element.append(WebComponent::getView(component))

      component.onDidRemoveComponent ({component}) ->
        try
          element.removeChild WebComponent::getView(component)
        catch e
          null

module.exports = WebComponent
