forever = require('forever');
forever.start(
  './ftp-service.coffee',
  {
    //uid: 'root',
    cwd: '/srv/www/yftp/current',
    command: './node_modules/.bin/coffee',
    spawnWith: {
      uid: 0, // Custom UID
      gid: 0  // Custom GID
    }
  }
);