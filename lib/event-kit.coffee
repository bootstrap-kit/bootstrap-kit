if atom
  {Disposable, CompositeDisposable, Emitter} = require "atom"
else
  {Disposable, CompositeDisposable, Emitter} = require "event-kit"

module.exports = {Disposable, CompositeDisposable, Emitter}
