Isomorphic logging driver
========
To use this package install an adapter *separately*:
 - [File](https://atmospherejs.com/ostrio/loggerfile) - Store application log messages into the file (FS), log rotation included;
 - [Mongo](https://atmospherejs.com/ostrio/loggermongo) - Store application log messages into MongoDB;
 - [Console](https://atmospherejs.com/ostrio/loggerconsole) - Print Client's application log messages to Server's console, messages colorized for better readability.

Features:
 - 100% tests coverage;
 - Flexible log level filters, ex: write `FATAL`, `ERROR`, and `WARN` to file, `DEBUG` to console, and all other to MongoDB;
 - `userId` is automatically passed and logged if logged data is associated with logged-in user;
 - Pass logs from *Client* to *Server*;
 - Catch all browser's errors.

## Installation:
```shell
meteor add ostrio:logger
```

## ES6 Import:
```jsx
import { Logger } from 'meteor/ostrio:logger';
```

## Usage
### Logger [*Isomorphic*]
```jsx
const log = new Logger();

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
log._(message, data, userId); //--> Plain shortcut

/* Use with throw */
throw log.error(message, data, userId);
```

### Catch-all Client's errors example: [*CLIENT*]
```jsx
/* Store original window.onerror */
const _GlobalErrorHandler = window.onerror;

window.onerror = (msg, url, line) => {
  log.error(msg, {file: url, onLine: line});
  if (_GlobalErrorHandler) {
    _GlobalErrorHandler.apply(this, arguments);
  }
};
```

### Catch-all Server's errors example: [*Server*]
```jsx
const bound = Meteor.bindEnvironment((callback) => {callback();});
process.on('uncaughtException', function (err) {
  bound(() => {
    log.error("Server Crashed!", err);
    console.error(err.stack);
    process.exit(7);
  });
});
```

### Catch-all Meteor's errors example: [*Server*]
```jsx
// store original Meteor error
const originalMeteorDebug = Meteor._debug;
Meteor._debug = (message, stack) => {
  const error = new Error(message);
  error.stack = stack;
  log.error('Meteor Error!', error);
  return originalMeteorDebug.apply(this, arguments);
  };
};
```

### Register new adapter [*Isomorphic*]
*Mainly should be used by adapter developers, a.k.a. developer API.*
```jsx
/* Emitter function
 * name        {String}    - Adapter name
 * emitter     {Function}  - Function called on Meteor.log...
 * init        {Function}  - Adapter initialization function
 * denyClient  {Boolean}   - Strictly deny execution on client
 * denyServer  {Boolean}   - Strictly deny execution on server
 * Example: log.add(name, emitter, init, denyClient, denyServer);
 */

const emitter = (level, message, data, userId) => {
  /* .. do something with a message .. */
};

const init = () => {
  /* Initialization function */
  /* For example create a collection */
  log.collection = new Meteor.Collection("logs");
};

log.add('AdapterName', emitter, init, true, false);
```

### Enable/disable adapter and set its settings [*Isomorphic*]
```jsx
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
  client: false, /* Allow to call, but not execute on Client */
  server: true   /* Calls from client will be executed on Server */
});
```

## Support this project:
This project wouldn't be possible without [ostr.io](https://ostr.io).

Using [ostr.io](https://ostr.io) you are not only [protecting domain names](https://ostr.io/info/domain-names-protection), [monitoring websites and servers](https://ostr.io/info/monitoring), using [Prerendering for better SEO](https://ostr.io/info/prerendering) of your JavaScript website, but support our Open Source activity, and great packages like this one could be available for free.
