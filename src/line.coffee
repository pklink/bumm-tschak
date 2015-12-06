BummTschak = exports ? this

class BummTschak.Line

  constructor: (@_metronome, sound) ->
    @_length = 16
    @_currentIndex = 0
    @_steps = []

    for number in [1..16]
      @_steps.push(new BummTschak.Step(sound))

    @_metronome.onStep(=>
      @current().off()
      @forward()
      @current().on()
    )

    @_metronome.onReset(=>
      step.off() for step in @_steps
      @_currentIndex = 0
    )

  current: ->
    @_steps[@_currentIndex]

  forward: ->
    if @_currentIndex == @_length-1 then @_currentIndex = 0
    else @_currentIndex++

  all: ->
    @_steps

  setLength: (@_length) ->
    @_metronome.reset()