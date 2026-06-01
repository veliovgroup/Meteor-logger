---
name: meteor-logger
description: >-
  Guides ostrio:logger and adapters (console, file, mongo) for Meteor 2 and 3.
  Use when adding logging, adapters, log levels, enable/filter rules, or debugging
  ostrio:logger, ostrio:loggerconsole, ostrio:loggerfile, ostrio:loggermongo.
license: MIT
metadata:
  author: veliovgroup
  packages: ostrio:logger,ostrio:loggerconsole,ostrio:loggerfile,ostrio:loggermongo
---

# Meteor Logger (ostrio:logger)

Isomorphic logging for Meteor.js: one `Logger` instance, multiple adapters (console, file, MongoDB).

## Install packages

```shell
meteor add ostrio:logger
meteor add ostrio:loggerconsole   # optional
meteor add ostrio:loggerfile      # optional
meteor add ostrio:loggermongo     # optional
```

**Meteor 3:** use `ostrio:logger` ≥ 2.2.0. Tested on Meteor 2.14–3.4.*.

## Quick start

```js
import { Logger } from 'meteor/ostrio:logger';
import { LoggerConsole } from 'meteor/ostrio:loggerconsole';
import { LoggerFile } from 'meteor/ostrio:loggerfile';
import { LoggerMongo } from 'meteor/ostrio:loggermongo';

const log = new Logger();

new LoggerConsole(log).enable();
new LoggerFile(log).enable();
new LoggerMongo(log).enable();

log.info('message', { extra: true }, userId);
log.error('failed', err);
throw log.fatal('critical', data); // throws LoggerMessage
```

## Reference docs

| Topic | File |
|-------|------|
| Core Logger API | [references/core.md](references/core.md) |
| Console adapter | [references/console.md](references/console.md) |
| File adapter | [references/file.md](references/file.md) |
| Mongo adapter | [references/mongo.md](references/mongo.md) |

## Agent skill install

```bash
npx skills add veliovgroup/Meteor-logger --skill meteor-logger -g
```

## Repos

| Package | Atmosphere | GitHub |
|---------|------------|--------|
| `ostrio:logger` | [logger](https://atmospherejs.com/ostrio/logger) | [Meteor-logger](https://github.com/veliovgroup/Meteor-logger) |
| `ostrio:loggerconsole` | [loggerconsole](https://atmospherejs.com/ostrio/loggerconsole) | [Meteor-logger-console](https://github.com/veliovgroup/Meteor-logger-console) |
| `ostrio:loggerfile` | [loggerfile](https://atmospherejs.com/ostrio/loggerfile) | [Meteor-logger-file](https://github.com/veliovgroup/Meteor-logger-file) |
| `ostrio:loggermongo` | [loggermongo](https://atmospherejs.com/ostrio/loggermongo) | [Meteor-logger-mongo](https://github.com/veliovgroup/Meteor-logger-mongo) |
