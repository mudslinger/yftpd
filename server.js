forever = require('forever');
forever.start(
  './ftp-service.coffee',
  {
    uid: 'root',
    command: './node_modules/.bin/coffee',
    spawnWith: {
      customFds: [-1, -1, -1], // that forever spawns.
      setsid: false,
      uid: 0, // Custom UID
      gid: 0  // Custom GID
    }
  }
);