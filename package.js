Package.describe({
  name: 'ostrio:logger',
  version: '1.1.2',
  summary: 'Logging: isomorphic driver with support of MongoDB, File (FS) and Console',
  git: 'https://github.com/VeliovGroup/Meteor-logger',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use(['coffeescript', 'reactive-var', 'check', 'underscore'], ['client', 'server']);
  api.use('tracker', 'client');
  api.addFiles('logger.coffee', ['client', 'server']);
  api.export('Logger');
});
