angular.module('BummTschak', [])

  .controller('AppController', ($scope) ->
    $scope.bpm = 90

    $scope.metronome = new Metronome($scope.bpm)
    $scope.metronome.onStep(=>
      $scope.$digest()
    )

    $scope.$watch('bpm', ->
      $scope.metronome.setTempo($scope.bpm)
    )

    $scope.play = ->
      $scope.metronome.start()

    $scope.stop = ->
      $scope.metronome.stop()

  )

  .directive('line', ->

    templateUrl: '_line.html'

    scope:
      metronome: '='
      soundUrl:  '@'
      length:    '@'

    link: (scope) ->
      scope.length = 16
      scope.model  = new Line(scope.metronome, new Sound(scope.soundUrl))

      scope.$watch('length', ->
        scope.model.setLength(scope.length)
      )

  )

  .directive('step', ->

    replace: true

    templateUrl: '_step.html'

    scope:
      model: '=ngModel'

    link: (scope) ->
      scope.toggle = -> scope.model.toggle()

  )


class Line

  constructor: (@_metronome, sound) ->
    @_length = 16
    @_currentIndex = 0
    @_steps = []

    for number in [1..16]
      @_steps.push(new Step(sound))

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


class Step

  constructor: (@_sound) ->
    @_isOn      = false
    @_isEnabled = false

  on: ->
    @_isOn = true
    @_sound.play() if @_isEnabled

  off: ->
    @_isOn = false

  isOn: () ->
    @_isOn

  enable: ->
    @_isEnabled = true

  disable: ->
    @_isEnabled = false

  toggle: ->
    @_isEnabled = !@_isEnabled

  isEnabled: () ->
    @_isEnabled


class Sound

  constructor: (@url) ->
    @_howl = new Howl(urls: [@url])

  play: -> @_howl.play()


class Metronome

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