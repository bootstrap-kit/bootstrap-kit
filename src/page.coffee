class Page extends WebComponent
  constructor: (args...) ->
    return new Page args... unless this instanceof Page
    super args...

window.views.addViewProvider Page, (page) ->
  pageElement = new PageElement
  pageElement.setModel(page)
  pageElement

window.views.addViewProvider Logo, (logo) ->
  div = document.createElement('div')
  div.innerHTML = """
    <a href="#{logo.href}" class="logo">
      <span class="logo-mini">#{logo.mini}</span>
      <span class="logo-lg">#{logo.lg}</span>
    </a>
  """
  div.firstChild
