Meteor isomorphic logger
========
Logger package to be used with any adapter, ex.: MongoDB, Log Files, Server and/or Client console. 
With range of settings, like Server and/or Client execution, filters by log levels (types, like `warn`, `info`, etc.).

Install:
========
```shell
meteor add ostrio:logger
```

Usage
========
##### Log [`Server` & `Client`]
```javascript
/*
  message {String} - Any text message
  data    {Object} - [optional] Any additional info as object
  userId  {String} - [optional] Current user id
 */
Meteor.log.info(message, data, userId);
Meteor.log.debug(message, data, userId);
Meteor.log.error(message, data, userId);
Meteor.log.fatal(message, data, userId);
Meteor.log.warn(message, data, userId);
```

#### Register new adapter [`Server` & `Client`]
```javascript
/*
  name        {String}    - Adapter name
  emitter     {Function}  - Function called on Meteor.log...
  init        {Function}  - Adapter initialization function
  denyClient  {Boolean}   - Strictly deny execution on client, only pass via Meteor.methons
 */
Meteor.log.add(name, emitter, init, denyClient);

var emitter = function(level, message, data, userId){
  Meteor.log.collection.insert({
    userId: userId,
    level: level,
    message: message,
    additional: data
  });
};

var init = function(){
  Meteor.log.collection = new Meteor.Collection("logs");
};

Meteor.log.add('Mongo', emitter, init, true);
```

#### Enable/disable and set settings adapter
```javascript
/*
  name    {String} - Adapter name
  options {Object} - Settings object, accepts next properties:
      enable {Boolean} - Enable/disable adapter
      filter {Array}   - Array of strings, accepts: 
                         'ERROR', 'FATAL', 'WARN', 'DEBUG', 'INFO', '*'
                         in lowercase and uppercase
                         default: ['*'] - Accept all
      client {Boolean} - Allow execution on Client
      server {Boolean} - Allow execution on Server
 */
Meteor.log.rule(name, options);

/* Examples: */
Meteor.log.rule('File', 
{
  enable: true,
  filter: ['ERROR', 'FATAL', 'WARN'],
  client: false, /* This allows to call, but not execute on Client */
  server: true   /* Calls from client will be executed on Server */
});

Meteor.log.rule('Console', 
{
  enable: true,
  filter: ['*'],
  client: true,
  server: true
});

Meteor.log.rule('Mongo',
{
  enable: true
}
});
```