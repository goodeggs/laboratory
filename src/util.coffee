module.exports =
  getSeedFromTime: (time) ->
    (time.getSeconds() + (time.getMinutes() * 60)) / 60 / 60
