angular.module('BummTschak', [])

  .controller('AppController', ->)

  .directive('line', ($interval) ->

    templateUrl: '_line.html'

    scope:
      soundUrl:   '@'

    link: (scope) ->
      scope.model = new Line(new Sound(scope.soundUrl))

      $interval(->
        scope.model.current().isActive = false
        scope.model.next().play()
      , 166)

  )

  .directive('step', ->

    replace: true

    templateUrl: '_step.html'

    scope:
      model: '=ngModel'

    link: (scope) ->
      # toggle selection of step
      scope.toggle = -> scope.model.isSelected = !scope.model.isSelected

  )


class Line

  constructor: (@sound) ->
    @_currentIndex = 0
    @steps = []

    # create 16 steps
    for number in [1..16]
      @steps.push(new Step(@sound))

  current: ->
    @steps[@_currentIndex]

  get: (number) ->
    @steps[number-1]

  next: ->
    if @_currentIndex == 15 then @_currentIndex = 0
    else @_currentIndex++
    @current()


class Step

  constructor: (@sound) ->
    @isActive   = false
    @isSelected = false

  play: ->
    @isActive = true
    @sound.play() if @isSelected


class Sound

  constructor: (@url) ->
    @_howl = new Howl(urls: [@url])


  play: -> @_howl.play()