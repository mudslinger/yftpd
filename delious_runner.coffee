
DeliousMaster = require './delious_master'

console.log 'getting deious menu master...'
dm = new DeliousMaster()
dm.load (data)->
  console.log 'runner'
  console.log data

sleep = require('sleep-async')()
console.log("before")
sleep.sleep 10000, ->
    console.log("after")