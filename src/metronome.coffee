class Metronome

  constructor: (@_bpm) ->
    @_interval  = null
    @_onStep    = []
    @_onReset   = []
    @_isRunning = false

  setTempo: (@_bpm) ->
    @reset()

  stop: ->
    # clear interval
    clearInterval(@_interval) if @_interval?
    @_interval = null

  start: ->
    if @_interval? then return

    # calculate interval time
    time = 60 / @_bpm / 4 * 1000

    # set interval
    @_interval = setInterval(
      # call every onStep-callback
      => fnc() for fnc in @_onStep
    , time)

  reset: ->
    restart = @_interval?

    @stop()

    # call every onReset-callback
    fnc() for fnc in @_onReset

    @start() if restart

  onStep: (fnc) ->
    @_onStep.push(fnc)

  onReset: (fnc) ->
    @_onReset.push(fnc)

module.exports = Metronome