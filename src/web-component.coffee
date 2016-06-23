{Emitter, CompositeDisposable}    = require './event-kit'
ViewRegistry = require './view-registry'
{str2elem}   = require './util'

views = null

# Private: Initialize View Registry
initViews = (object) ->
  object.views = views = new ViewRegistry()

  # View of a standard web component is HTML representation of its string.
  views.addViewProvider WebComponent, (object) ->
    e = str2elem(object.getString() or '<div></div>')

    if object.action
      e.addEventListener 'click', ->
        object.trigger()

    object.manageComponentViews(e)

    return e

# Public: Provide a web component.
#
# A web component is a model of some data.  WebComponent objects are passed
# to views to display the data.
class WebComponent
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
  # ```coffee
  #    component = new WebComponent "<b>Hello World</b>")
  #    document.querySelector('body').append WebComponent::getView component
  # ```
  #
  # Returns the `<b>` HTMLElement object.
  #
  constructor: (args...) ->
    return new WebComponent args... if this not instanceof WebComponent

    @options     ?= {}
    @string       = null
    @components   = []
    @emitter     ?= new Emitter()
    @container    = null
    @subscription = new CompositeDisposable()
    @data         = null

    if args.length > 0
      if typeof args[0] is 'string'
        @string = args[0]
        args = args[1...]

    if args.length > 0
      if not (
          (args[0] instanceof WebComponent) or
          (args[0] instanceof Array) or
          (args[0] instanceof Function)
        )
        @options = args[0]
        args = args[1...]

    if args.length > 0
      action = args[args.length-1]
      if action instanceof Function
        @action = action
        @onDidTrigger action
        args = args[0...-1]

    if @options.data
      @setData @options.data
      delete @options.data

    @addComponents args...


  ###
  Section: View Management

  WebComponent manages a singleton{ViewRegistry} instance view class methods.
  ###

  # Public: Get the view for an object.
  #
  # ```coffee
  # document.querySelector('body').append WebComponent.getView(object)
  # ```
  @getView: (component) ->
    views.getView(component)

  # Public: Check, if there is a view defined for object
  #
  # ```coffee
  # WebComponent.hasView(object)
  # ```
  @hasView: (component) ->
    views.hasView(component)

  # Public: Add a view provider for some model class.
  #
  # ```coffee
  # class MyClass extends WebComponent
  #
  # WebComponent.addViewProvider MyClass, (component) ->
  #   # return a view for given component
  #
  @addViewProvider: (modelClass, callback) ->
    views.addViewProvider modelClass, callback

  # Public: Get the view Provider Function for some model class
  #
  @getViewProvider: (modelClass) ->
    views.getViewProvider modelClass

  # Extended: Clear the view registry
  #
  # Create a clear new view registry.  This is usually only used between tests
  # to have a new defined clean view registry.
  #
  # ```coffee
  # WebComponent.clearViewRegistry()
  # ```
  @clearViewRegistry: ->
    initViews(WebComponent)


  ###
  Section: String API
  ###

  # Public: Get string, which has been passed to constructor
  #
  getString: ->
    @string or ''

  ###
  Section: Data API
  ###

  # Public: Update data stored in component
  updateData: (object) ->
    changes = {}

    if object instanceof Array
      oldValue = @data
      newValue = object
      changes = {oldValue, newValue}
      @data = newValue

    else
      @data = {} unless @data?

      for name, newValue of object
        if (oldValue = @data[name] or null) != newValue
          changes[name] = {oldValue, newValue}
          @data[name] = newValue

    if JSON.stringify(changes) isnt '{}'
      @emitter.emit 'did-update-data', {changes, @data}

  # Public: Clear the data stored in component
  clearData: ->
    @data = null
    @emitter.emit 'did-clear-data'

  # Public: Set data store stored in component
  setData: (args...) ->
    if args.length is 2
      obj = {}
      obj[args[0]] = args[1]
      @updateData obj

    else
      @clearData()
      @updateData(object)
      @emitter.emit 'did-set-data', @data
      @data

  # Public: Get data stored in component
  getData: (name) ->
    if name?
      @data[name]
    else
      @data

  # Public: Invoke the given callback if data has been updated
  #
  # * `callback` {Function} to be called if data updated
  #   * `info` {Object} with the following keys
  #
  #     - `changes` {Object} keys are of items in data changed and each item
  #       is an {Object} having `oldValue` and `newValue`
  #     - `data` {Object} updated data
  #
  # Returns a {Disposable} on which `.dispose()` can be called to unsubscribe.
  onDidUpdateData: (callback) ->
    @emitter.on 'did-update-data', callback

  # Public: Invoke the given callback if data has been set
  #
  # * `callback` {Function} to be called if data set
  #   * `data` {Object} data object of this component
  #
  # Returns a {Disposable} on which `.dispose()` can be called to unsubscribe.
  onDidSetData: (callback) ->
    @emitter.on 'did-set-data', callback

  # Public: Invoke the given callback if data has been cleared
  #
  # Returns a {Disposable} on which `.dispose()` can be called to unsubscribe.
  onDidClearData: (callback) ->
    @emitter.on 'did-clear-data', callback

  ###
  Section: View API
  ###

  # Public: Set view of this component
  #
  # * `view` to be set
  #
  # Either replace or set view of this component to be `view`
  setView: (view) ->
    if views.hasView(this)
      views.replaceView(this, view)
      @options.view = view
    else
      @options.view = view
      views.getView(this)

  # Public: Get view of this component
  #
  # * `selector` an optional selector, which is applied with `querySelector`
  #
  # Returns view for this component.
  getView: (selector) ->
    if selector
      WebComponent.getView(this).querySelector(selector)
    else
      WebComponent.getView(this)

  ###
  Section: Managing Components
  ###

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

    if action
      component.onDidTrigger action

    autoAttachComponents = @options.autoAttachComponents ? true

    if autoAttachComponents and WebComponent.hasView(this)
      @attachComponentView WebComponent.getView(this), component

    @emitter.emit 'did-add-component', {parent: this, component}
    component.emitter.emit 'did-add-this-component', {parent: this, component}

    component

  # Public: Get a Component
  getComponent: (index=0) ->
    @components[index]

  # Public: Get Components
  getComponents: ->
    @components

  # Public: Get next Component
  getNextComponent: (component) ->
    next = @components.indexOf(component) + 1
    if next >= @components.length
      null
    else
      @components[next]

  # Public: Get previous Component
  getPrevComponent: (component) ->
    prev = @components.indexOf(component) - 1

    if index < 0
      null
    else
      @components[index]

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


  # Public: update components, which are keyed
  updateComponentsKeyedList: (args...) ->
    visited = []
    key = @options.key

    @keyed ?= {}
    for arg in args
      @keyed

      for item in data
        unless item.name of @hosts
          @addComponent new VMHost()

        @hosts[item.name].update(item)
        visited.push @hosts[item.name]

      for component in @getComponents()
        if visited.indexOf(component) < 0
          @removeComponent(component)

  # updateComponentsKeyed: (model, data) ->
  #   visited = []
  #
  #   for key, value of data
  #     if key not of @keyed
  #       item = new model()
  #       @addComponent item
  #       @keyed[key] = item
  #

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

  # Public: Remove all components
  removeComponents: () ->
    for component in @getComponents()
      @removeComponent(component)

  # Public: Invoke callback if component has been triggered
  onDidTrigger: (callback) ->
    console.log 'onDidTrigger', callback
    @emitter.on 'did-trigger', callback

  # Public: Trigger the component
  trigger: ->
    console.log 'trigger', this
    @emitter.emit 'did-trigger', this

  # Public: Invoke the given callback if this component is added to a containing component
  #
  # * `callback` {Function} to be called after this component is added to another
  #   * `container` {WebComponent} component this is added to
  onDidAddThisComponent: (callback) ->
    @emitter.on 'did-add-this-component', callback

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

  # Public: install an event handler for auto managing child component views
  #
  # * `element` - HTMLElement to append the views to
  #
  # This is a convenience function for observing views, adding them to given
  # view and removing it if component has been removed.
  #
  manageComponentViews: (element) ->
    @observeComponents (component) =>
      @attachComponentView element, component

  attachComponentView: (element, component) ->
    element.appendChild(WebComponent.getView(component))

    component.onDidRemoveComponent ({component}) ->
      try
        element.removeChild WebComponent.getView(component)
      catch e
        null

initViews(WebComponent)

module.exports = WebComponent
