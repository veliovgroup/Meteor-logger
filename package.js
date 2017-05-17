Package.describe({
  name: 'ostrio:logger',
  version: '2.0.1',
  summary: 'Logging: isomorphic driver with support of MongoDB, File (FS) and Console',
  git: 'https://github.com/VeliovGroup/Meteor-logger',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.4');
  api.use(['ecmascript', 'reactive-var', 'check', 'underscore'], ['client', 'server']);
  api.mainModule('logger.js', ['client', 'server']);
});

Package.onTest(function(api) {
  api.use('tinytest');
  api.use(['ecmascript', 'underscore', 'ostrio:logger']);
  api.addFiles('logger-tests.js');
});
