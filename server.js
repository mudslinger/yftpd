require('coffee-script/register');
var forever = require('forever');
var express = require('express');

var cron = require('./cron.coffee');

var app = express();
app.set('port', 80);
app.get('/',function(req, res){
  res.send("express is running.");
});
app.listen(80);
console.log('Express listening on port 80');

forever.start(
  'ftp-service.js',
  {
    uid: 'root',
    outFile: "/srv/www/yftp/current/log/stdout.log",
    errFile: "/srv/www/yftp/current/log/stderr.log",
    spawnWith: {
      uid: 0, // Custom UID
      gid: 0  // Custom GID
    }
  }
);

// cron.start();
// console.log('Cron service started.');

process.on('exit', function(code) {
  forever.stopAll(true);
});

