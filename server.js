var forever = require('forever');
var express = require('express');

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
    logFile: '/srv/www/yftp/current/log.log'
    outFile: '/srv/www/yftp/current/stdout.log', // Path to log output from child stdout
    errFile: '/srv/www/yftp/current/stderr.log', // Path to log output from child stderr
    spawnWith: {
      uid: 0, // Custom UID
      gid: 0  // Custom GID
    }
  }
);
