Isomorphic logging driver
========
Logger package to be used with any adapter, ex.: [MongoDB](https://atmospherejs.com/ostrio/loggermongo), [Log files](https://atmospherejs.com/ostrio/loggerfile), Server and/or Client [console](https://atmospherejs.com/ostrio/loggerconsole). 
With range of settings, like Server and/or Client execution, filters by log levels (types, like `warn`, `info`, etc.).

Install:
========
```shell
meteor add ostrio:logger
```

Usage
========
To use this package you need to install an adapter:
 - [File](https://atmospherejs.com/ostrio/loggerfile) - Simply store application logs into file within ostrio:logger package;
 - [Mongo](https://atmospherejs.com/ostrio/loggermongo) - Simply store application logs into MongoDB within ostrio:logger package;
 - [Console](https://atmospherejs.com/ostrio/loggerconsole) - Simply output Client application logs into Server's console within ostrio:logger package.

##### Logger [*Isomorphic*]
```javascript
this.Log = new Logger();
/*
  message {String|Number} - Any text message
  data    {Object} - [optional] Any additional info as object
  userId  {String} - [optional] Current user id
 */
Log.info(message, data, userId);
Log.debug(message, data, userId);
Log.error(message, data, userId);
Log.fatal(message, data, userId);
Log.warn(message, data, userId);
Log.trace(message, data, userId);
Log._(message, data, userId); //--> Shortcut for logging without message, e.g.: simple plain log

/* Use with throw */
throw Log.error(message, data, userId);
```

##### Catch-all client's errors: [*CLIENT*]
```javascript
/* Store original window.onerror */
this.Log = new Logger();
/* Log to file: */
/* https://github.com/VeliovGroup/Meteor-logger-file */
new LoggerFile(Log).enable();
var _WoE = window.onerror;

window.onerror = function(msg, url, line) {
  Log.error(msg, {file: url, onLine: line});
  if (_WoE) {
    _WoE.apply(this, arguments);
  }
};
```

##### Register new adapter [*Isomorphic*]
```javascript
/*
  name        {String}    - Adapter name
  emitter     {Function}  - Function called on Meteor.log...
  init        {Function}  - Adapter initialization function
  denyClient  {Boolean}   - Strictly deny execution on client, only pass via Meteor.methods
  Example: Log.add(name, emitter, init, denyClient);
 */

var emitter = function(level, message, data, userId){
  Log.collection.insert({
    userId: userId,
    level: level,
    message: message,
    additional: data
  });
};

var init = function(){
  Log.collection = new Meteor.Collection("logs");
};

Log.add('Mongo', emitter, init, true);
```

##### Enable/disable adapter and set it's settings [*Isomorphic*]
```javascript
/*
  name    {String} - Adapter name
  options {Object} - Settings object, accepts next properties:
  options.enable {Boolean} - Enable/disable adapter
  options.filter {Array}   - Array of strings, accepts: 
                             'ERROR', 'FATAL', 'WARN', 'DEBUG', 'INFO', '*'
                             in lowercase and uppercase
                             default: ['*'] - Accept all
  options.client {Boolean} - Allow execution on Client
  options.server {Boolean} - Allow execution on Server
  Example: Log.rule(name, options);
 */

/* Examples: */
Log.rule('File', {
  enable: true,
  filter: ['ERROR', 'FATAL', 'WARN'],
  client: false, /* This allows to call, but not execute on Client */
  server: true   /* Calls from client will be executed on Server */
});

Log.rule('Console', {
  enable: true,
  filter: ['*'],
  client: true,
  server: true
});

Log.rule('Mongo',{
  enable: true
});
```