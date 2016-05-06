{str2elem} = require './util.coffee'

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

  hasView: (object) ->
    for view in @views
      if view.object is object
        return true
    return false

  removeView: (object) ->
    for view in @views
      if view.object is object
        @views.remove(view)
        return true

    return false

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
    # first check if object knows its view
    view = null
    if object.options?.view
      view = object.options.view
    else if object.view
      view = object.view

    if view?
      if view instanceof HTMLElement
        return view

      if view instanceof Function
        return view(object)

      if typeof view is 'string'
        if view.startswith('<')
          return str2elem(view)
        else
          return document.querySelector(view)

    # look, if there is a
    for view in @views
      if view.object is object
        return view.view

    for viewProvider in @viewProviders
      if object.constructor is viewProvider.modelClass
        o = {}
        o.object = object

        if typeof viewProvider.factory is 'string'
          o.view = str2elem(viewProvider.factory)
        else
          o.view = viewProvider.factory(object)

        @views.push o
        return o.view

    throw new Error("Cannot find view for object #{object}")
