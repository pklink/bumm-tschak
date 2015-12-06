angular.module('BummTschak', [])

  .controller('AppController', ->)

  .directive('line', ($interval) ->

    templateUrl: '_line.html'

    scope:
      soundUrl:   '@'

    link: (scope) ->
      scope.model = new Line(new Sound(scope.soundUrl))

      $interval(->
        scope.model.current().off()
        scope.model.forward()
        scope.model.current().on()
      , 166)

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

  constructor: (sound) ->
    @_currentIndex = 0
    @_steps = []

    # create 16 steps
    for number in [1..16]
      @_steps.push(new Step(sound))

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