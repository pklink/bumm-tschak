Metronome = require('./metronome.coffee')
Line      = require('./line.coffee')
Sound     = require('./sound.coffee')

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

    template: require('./views/line.html')

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

    template: require('./views/step.html')

    scope:
      model: '=ngModel'

    link: (scope) ->
      scope.toggle = -> scope.model.toggle()

  )