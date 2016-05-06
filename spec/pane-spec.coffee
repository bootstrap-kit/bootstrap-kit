{Pane, SidebarMenu, MenuItem} = require '../lib/main.coffee'

describe "Using Panes", ->
  pane = null
  sidebar = null

  beforeEach ->
    pane = new Pane()
    sidebar = new SidebarMenu()

    pane.observeComponents (component) ->
      menuItem = new MenuItem component.options.title, ->
        component.activateItem()
      sidebar.addComponent(menuItem)

    pane.addComponent """<div>Hello World</div>""", title: 'greet'
    pane.addComponent """<div>Bye World</div>""", title: 'goodbye'

  it "can update sidebar when adding a pane-item", ->
    expect(sidebar.getComponent(0).string).toBe 'greet'
    expect(sidebar.getComponent(1).string).toBe 'goodbye'
