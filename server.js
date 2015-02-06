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
  '/srv/www/yftp/current/ftp-service.coffee',
  {
    uid: 'root',
    command: '/srv/www/yftp/current/node_modules/.bin/coffee',
    spawnWith: {
      uid: 'root', // Custom UID
      gid: 'root'  // Custom GID
    }
  }
);
