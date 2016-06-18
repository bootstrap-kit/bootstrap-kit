{CompositeDisposable} = require './event-kit'
WebComponent = require './web-component'
{copyProperties} = require './util'

class FormElement extends HTMLDivElement
  setModel: (@model) ->
    @model.form = new JSONEditor this, schema: @model.options.schema
    this

module.exports = document.registerElement 'btk-form',
  extends: 'div', prototype: FormElement::
