DeliousMaster = require './delious_master'
CronJob = require("cron").CronJob

delious_master = ->
  console.log 'getting deious menu master...'
  dm = new DeliousMaster()
  dm.load (data)->
    console.log data

module.exports = job = new CronJob
  cronTime: "*/10 * * * * *"
  onTick: ->
    delious_master()
    return
  start: false