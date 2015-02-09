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
    logFile: './log.log'
    outFile: './stdout.log', // Path to log output from child stdout
    errFile: './stderr.log', // Path to log output from child stderr
    spawnWith: {
      uid: 0, // Custom UID
      gid: 0  // Custom GID
    }
  }
);
