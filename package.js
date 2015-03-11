Package.describe({
  name: 'ostrio:logger',
  version: '0.0.3',
  summary: 'Meteor isomorphic logger driver',
  git: 'https://github.com/VeliovGroup/Meteor-logger',
  documentation: 'README.md'
});

Package.onUse(function(api) {
  api.versionsFrom('1.0.3.1');
  api.use('coffeescript', ['client', 'server']);
  api.use(['session'], ['client', 'server']);
  api.addFiles('ostrio:logger.coffee', ['client', 'server']);
});
