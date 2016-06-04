{CompositeDisposable} = require './event-kit'
WebComponent = require './web-component'
PaneView = require './pane-view'
{copyProperties} = require './util'

class PaneElement extends HTMLDivElement

copyProperties PaneView::, PaneElement::

module.exports = document.registerElement 'btk-pane',
  extends: 'div', prototype: PaneElement.prototype
