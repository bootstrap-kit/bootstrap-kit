ViewRegistry = require '../lib/view-registry.coffee'

describe 'view registry', ->
  it 'can add a view provider', ->
    views = new ViewRegistry

    class MyModel
      constructor: (@name) ->

    views.addViewProvider MyModel, (mymodel) ->
      div = document.createElement('div')
      div.innerHTML = "<b>hello #{mymodel.name}</b>"
      div.firstChild

    mm = new MyModel('world')
    elem = views.getView(mm)

    expect(elem.textContent).toBe 'hello world'
