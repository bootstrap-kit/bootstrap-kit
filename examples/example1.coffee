var body = document.querySelector('body')

// AdminLTE
page = Page class: 'wrapper' [
  Header class: 'main-header', [
    Brand [ Anchor "<b>FOO</b>", ->
      home.activateItem()
    ]
  ],

#  Pane class: 'container-fluid', [
  Pane [
    home = PaneItem [
      Aside class: 'main-sidebar', [
        sidebar = Sidebar [
        ]
      ]

      Pane class: 'content-wrapper', target: 'section.content'
        contentHeader = Section class: 'content-header'
        content       = Section class: 'content'
      ]
    ]
  ]
]

# Or:


contentHeader = WebComponent view: 'section.content-header'
content       = Pane view: 'section.content'

# myPane.onDidActivateItem ({item}) ->
#   item.

myPane.observeComponents (component) ->
#  component.options.glyph
  c = navbar.addComponent """<a href="#">#{component.title}</a>""", ->
    component.activateItem()


#Pane
