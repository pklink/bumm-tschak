class Sound

  constructor: (@url) ->
    @_howl = new Howl(urls: [@url])

  play: -> @_howl.play()

module.exports = Sound