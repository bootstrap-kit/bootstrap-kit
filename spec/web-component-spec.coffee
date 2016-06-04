WebComponent = require '../src/web-component'

describe "WebComponent", ->

  beforeEach ->
    WebComponent.clearViewRegistry()

  it "can be created", ->
    component = new WebComponent
    expect(component instanceof WebComponent).toBe true

  it "can be created with a list of components", ->
    component = new WebComponent [
      new WebComponent()
      new WebComponent()
    ]

    expect(component.components.length).toEqual 2
    expect(component.components[0] instanceof WebComponent).toBe true
    expect(component.components[1] instanceof WebComponent).toBe true

  it "can be passed options as first argument", ->
    component = new WebComponent foo: 'bar', [
      new WebComponent()
      new WebComponent()
    ]

    expect(component.options.foo).toBe 'bar'
    expect(component.components.length).toEqual 2
    expect(component.components[0] instanceof WebComponent).toBe true
    expect(component.components[1] instanceof WebComponent).toBe true

  it "can be passed a string as first argument", ->
    component = new WebComponent 'bar', [
      new WebComponent()
      new WebComponent()
    ]

    expect(component.getString()).toBe 'bar'
    expect(component.components.length).toEqual 2
    expect(component.components[0] instanceof WebComponent).toBe true
    expect(component.components[1] instanceof WebComponent).toBe true

  it "can be used as component without deriving a class", ->
    component = new WebComponent '<b>foo</b>'
    expect(WebComponent.getView(component).tagName).toBe 'B'
