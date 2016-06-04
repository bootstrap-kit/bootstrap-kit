{Pane, SidebarMenu, MenuItem, WebComponent} = require '../src/main'

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

  describe "Pane views", ->
    paneElement = null
    sidebarElement = null

    it "can be passed a target view", ->
      paneElement = document.createElement 'div'
      sidebarElement = document.createElement 'div'

      pane = new Pane view: paneElement
      sidebar = new SidebarMenu view: sidebarElement
      sidebar.manageComponentsViews(sidebarElement)

      pane.observeComponents (component) ->
        menuItem = new MenuItem component.options.title, ->
          component.activateItem()

        sidebar.addComponent(menuItem)

      pane.addComponent """<div>Hello World</div>""", title: 'greet'
      pane.addComponent """<div>Bye World</div>""", title: 'goodbye'

      expect(paneElement.childNodes.length).toBe 1
      expect(paneElement.childNodes[0]).toBe WebComponent.getView(pane.getComponent(0))

      expect(sidebarElement.childNodes.length).toBe 2
      expect(sidebarElement.childNodes[0].innerHTML).toBe 'greet'
      expect(sidebarElement.childNodes[1].innerHTML).toBe 'goodbye'
