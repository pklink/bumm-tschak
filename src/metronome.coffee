BummTschak = exports ? this

class BummTschak.Metronome

  constructor: (@_bpm) ->
    @_interval = null
    @_onStep  = []
    @_onReset  = []

  setTempo: (@_bpm) ->
    @reset()

  stop: ->
    clearInterval(@_interval) if @_interval?
    @_interval = null

  start: ->
    @stop()

    @_interval = setInterval(
      => fnc() for fnc in @_onStep
    , 60 / @_bpm / 4 * 1000)

  reset: ->
    restart = @_interval?
    @stop()
    fnc() for fnc in @_onReset
    @start() if restart

  onStep: (fnc) ->
    @_onStep.push(fnc)

  onReset: (fnc) ->
    @_onReset.push(fnc)