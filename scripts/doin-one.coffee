# Description:
#   Let's talk about doin' one.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   doin(') one - get a message
#
# Author:
#   Drew

module.exports = (robot) ->
  robot.hear /doin'? (one|1)/i, (msg) ->
    timeBasedMessage(msg)

  robot.hear /doin'? (two|three|four|five|2|3|4|5)/i, (msg) ->
    msg.send "No.  No, man.  Excrement, no, man.  I believe you'd get your posterior kicked sayin' something like that, man."

  robot.hear /do one/i, (msg) ->
    room = msg.message.room

    if room is "Doin' One"
      timeBasedMessage(msg)

  timeBasedMessage = (msg) ->
    now = new Date()
    targetTime = 17
    if now.getDay() is 5
      targetTime = 16

    padTime = (number) ->
      pad = "0000"
      output = pad + number + ""
      output.substr(output.length - 2);

    untilFivePm = targetTime - now.getHours()
    minutes = 60 - now.getMinutes()
    seconds = 60 - now.getSeconds()
    message = ""
    beerUrl = ""

    if now.getDay() is 0 or now.getDay() is 6
      untilFivePm = 0

    if untilFivePm <= 0
      message = "OMFG YER LATE!"
    if untilFivePm > 0
      message = "T-00:#{padTime(minutes)}:#{padTime(seconds)} and counting..."
    if untilFivePm > 1
      message = "It's so close I can taste it..."
    if untilFivePm > 2
      message = "It's so close I can smell it..."
    if untilFivePm > 3
      message = "We're getting closer to one..."
    if untilFivePm > 4
      message = "It's going to be a while..."

    message += "  But here's what one looks like."

    robot.http("https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=beer")
      .header('Accept', 'application/json')
      .get() (err, res, body) ->
        data = JSON.parse body
        if data.responseData.results.length > 0
          target = Math.floor(Math.random() * data.responseData.results.length)
          beerUrl = data.responseData.results[target].tbUrl + "#.png"
          msg.send message
          msg.send beerUrl