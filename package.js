Package.describe({
  name: 'ostrio:logger',
  version: '1.1.0',
  summary: 'Logging: isomorphic driver for MongoDB, File and Console',
  git: 'https://github.com/VeliovGroup/Meteor-logger',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use(['coffeescript', 'reactive-var'], ['client', 'server']);
  api.use('tracker', 'client');
  api.addFiles('logger.coffee', ['client', 'server']);
  api.export('Logger');
});
