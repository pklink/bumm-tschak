BummTschak = exports ? this

angular.module('BummTschak', [])

  .controller('AppController', ($scope) ->
    $scope.bpm = 90

    $scope.metronome = new BummTschak.Metronome($scope.bpm)
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
      scope.model  = new Line(scope.metronome, new BummTschak.Sound(scope.soundUrl))

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