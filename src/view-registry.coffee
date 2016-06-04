{str2elem} = require './util'

module.exports =
class ViewRegistry
  constructor: ->
    @viewProviders = []
    @views = []

  # Public: add view provider for a given class (usually {WebComponent})
  #
  # * `modelClass` class of model to provide view for
  # * `factory` either an HTML string or a function:
  #   * `object` object to create view for
  #   Returns an HTML Element.
  #
  # Returns
  addViewProvider: (modelClass, factory) ->
    @viewProviders.push {modelClass, factory}

  getViewProvider: (modelClass) ->
    for viewProvider in @viewProviders
      if modelClass.constructor is viewProvider.modelClass
        return viewProvider.factory

  hasView: (object) ->
    if object.options?.view?
      return true

    for view in @views
      if view.object is object
        return true
    return false

  replaceView: (object, newView) ->
    currentView = @getView(object)

    if object.options?.view?
      object.options.view = newView
    else
      for view, i in @views
        if view.object is object
          @views[i] = view = {object, view: newView}
          break

    if currentView.parentElement
      currentView.parentElement.replaceChild(@getView(object), currentView)

  removeView: (object) ->
    for view in @views
      if view.object is object
        @views.remove(view)
        delete object.view
        # TODO: remove view from DOM
        return true

    return false

  makeView: (view) ->
    if view instanceof HTMLElement
      return view

    if view instanceof Function
      return view(object)

    if typeof view is 'string'
      if view.match /^</ and view.match />$/
        return str2elem(view)
      else
        return document.querySelector(view)


  # Public: get view for object
  #
  # * `object` - object to get the view for
  #
  # Returns view for given object.  View is an HTML Element.
  #
  # Algorithm:
  # 1. If `object` has `options` key and this is an object having a `view`
  #    key (`object.options.view`) or `object` has `view` key:
  #
  #    - return `value` in case it is an {HTMLElement}
  #    - return `value(object)` in case it is a {Function}
  #    - return transform `value` to element in case it is a string and starts
  #      with '<'
  #    - return `document.querySelector(value)` in case it is a string
  #
  # 2. If there is a view in current view list, return it
  #
  # 3. Search for a previously registered ViewProvider for given object's class,
  #    create view, add it to current view list and return it
  #
  getView: (object) ->
    # look, if there is registered a view for this object
    if object.view
      return object.view

    # check if object knows its view
    view = null
    if object.options?.view
      view = makeView object.options.view
    else
      for viewProvider in @viewProviders
        if object.constructor is viewProvider.modelClass
          if typeof viewProvider.factory is 'string'
            view = str2elem(viewProvider.factory)
          else
            view = viewProvider.factory(object)

          break

    unless view
      throw new Error("Cannot find view for object #{object}")

    @views.push {object, view}
    object.view = view

    return view
