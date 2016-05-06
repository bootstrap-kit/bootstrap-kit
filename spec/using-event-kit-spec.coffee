{Emitter} = require '../lib/event-kit.coffee'

describe 'using event-kit', ->
  it "can use event-kit", ->
    emitter = new Emitter
    value = false
    emitter.on 'foo', ->
      value = true
    emitter.emit 'foo'

    expect(value).toBe true
