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

  )

  .directive('line', ->

    templateUrl: '_line.html'

    scope:
      metronome: '='
      soundUrl:  '@'

    link: (scope) ->
      scope.model = new Line(scope.metronome, new Sound(scope.soundUrl))

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
    @_currentIndex = 0
    @_steps = []

    for number in [1..16]
      @_steps.push(new Step(sound))

    @_metronome.onStep(=>
      @current().off()
      @forward()
      @current().on()
    )

  current: ->
    @_steps[@_currentIndex]

  forward: ->
    if @_currentIndex == 15 then @_currentIndex = 0
    else @_currentIndex++

  all: ->
    @_steps


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

  constructor: (bpm) ->
    @_interval = null
    @_onStep  = []

    @setTempo(bpm)

  setTempo: (bpm) ->
    clearInterval(@_interval) if @_interval?

    @_interval = setInterval(
      => fnc() for fnc in @_onStep
    , 60 / bpm / 4 * 1000)

  onStep: (fnc) ->
    @_onStep.push(fnc)
