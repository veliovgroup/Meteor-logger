Package.describe({
  name: 'ostrio:logger',
  version: '0.0.7',
  summary: 'Meteor isomorphic logger driver',
  git: 'https://github.com/VeliovGroup/Meteor-logger',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0');
  api.use('coffeescript', ['client', 'server']);
  api.use(['reactive-var', 'tracker'], 'client');
  api.addFiles('logger.coffee', ['client', 'server']);
});
