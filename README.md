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
To use this package install an adapter *separately*:
 - [File](https://atmospherejs.com/ostrio/loggerfile) - Store application log messages into file (FS);
 - [Mongo](https://atmospherejs.com/ostrio/loggermongo) - Store application log messages into MongoDB;
 - [Console](https://atmospherejs.com/ostrio/loggerconsole) - Print Client's application log messages to Server's console, messages colorized for better readability.

##### Logger [*Isomorphic*]
```javascript
this.log = new Logger();

/* Activate adapters with default settings */
/* meteor add ostrio:loggerfile */
new LoggerFile(log).enable();
/* meteor add ostrio:loggermongo */
new LoggerMongo(log).enable();
/* meteor add ostrio:loggerconsole */
new LoggerConsole(log).enable();

/* Log message
 * message {String|Number} - Any text message
 * data    {Object} - [optional] Any additional info as object
 * userId  {String} - [optional] Current user id
 */
log.info(message, data, userId);
log.debug(message, data, userId);
log.error(message, data, userId);
log.fatal(message, data, userId);
log.warn(message, data, userId);
log.trace(message, data, userId);
log._(message, data, userId); //--> Plain log without level

/* Use with throw */
throw log.error(message, data, userId);
```

##### Catch-all Client's errors example: [*CLIENT*]
```javascript
/* Store original window.onerror */
var _WoE = window.onerror;

window.onerror = function(msg, url, line) {
  log.error(msg, {file: url, onLine: line});
  if (_WoE) {
    _WoE.apply(this, arguments);
  }
};
```

##### Register new adapter [*Isomorphic*]
```javascript
/* Emitter function
 * name        {String}    - Adapter name
 * emitter     {Function}  - Function called on Meteor.log...
 * init        {Function}  - Adapter initialization function
 * denyClient  {Boolean}   - Strictly deny execution on client
 * Example: log.add(name, emitter, init, denyClient);
 */

var emitter = function(level, message, data, userId){
  /* .. do something with a message .. */
};

var init = function(){
  /* Initialization function */
  /* For example create a collection */
  log.collection = new Meteor.Collection("logs");
};

log.add('AdapterName', emitter, init, true);
```

##### Enable/disable adapter and set it's settings [*Isomorphic*]
```javascript
/*
 * name    {String} - Adapter name
 * options {Object} - Settings object, accepts next properties:
 * options.enable {Boolean} - Enable/disable adapter
 * options.filter {Array}   - Array of strings, accepts: 
 *                            'ERROR', 'FATAL', 'WARN', 'DEBUG', 'INFO', '*'
 *                            in lowercase and uppercase
 *                            default: ['*'] - Accept all
 * options.client {Boolean} - Allow execution on Client
 * options.server {Boolean} - Allow execution on Server
 * Example: log.rule(name, options);
 */

/* Example: */
log.rule('AdapterName', {
  enable: true,
  filter: ['ERROR', 'FATAL', 'WARN'],
  client: false, /* This allows to call, but not execute on Client */
  server: true   /* Calls from client will be executed on Server */
});
```