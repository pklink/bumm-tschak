BummTschak = exports ? this

class BummTschak.Step

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
