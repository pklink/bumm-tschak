angular.module('drumyApp', [])

  .controller('AppController', ->)

  .directive('line', ($interval) ->

    templateUrl: '_line.html'

    scope:
      step: '=?'
      soundUrl:  '@'

    link: (scope) ->
      scope.step ?= 1
      scope.sound = new Howl(
        urls: [scope.soundUrl]
      )

      $interval(->
        if scope.step == 16 then scope.step = 1
        else scope.step++
      , 166)

  )

  .directive('step', ->

    replace: true

    templateUrl: '_step.html'

    scope:
      isActive:   '=?'
      isSelected: '=?'
      sound:      '='

    link: (scope) ->
      scope.isActive   ?= false
      scope.isSelected ?= false

      scope.$watch('isActive', ->
        if scope.isActive and scope.isSelected
          scope.sound.play()
      )

      # toggle selection of step
      scope.toggle = -> scope.isSelected = !scope.isSelected

  )

