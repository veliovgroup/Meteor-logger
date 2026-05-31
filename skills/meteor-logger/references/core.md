# ostrio:logger — core API

## Logger

```js
import { Logger, LoggerMessage } from 'meteor/ostrio:logger';

const log = new Logger();
```

### Log levels

| Method | Level |
|--------|-------|
| `log.info(msg, data?, userId?)` | INFO |
| `log.debug(...)` | DEBUG |
| `log.error(...)` | ERROR |
| `log.fatal(...)` | FATAL |
| `log.warn(...)` | WARN |
| `log.trace(...)` | TRACE (adds `stackTrace` in data/details on server) |
| `log._(...)` | LOG (shortcut) |

All methods return `LoggerMessage`. Use `throw log.error(...)` to throw a log record.

### LoggerMessage

- `message`, `data`, `userId`, `level`, `details`, `reason`, `error`
- `toString()` — human-readable summary

### Custom adapters

```js
log.add('MyAdapter', (level, message, data, userId) => {
  // handle log
}, initFn, denyClient, denyServer);

log.rule('MyAdapter', {
  enable: true,
  filter: ['ERROR', 'WARN'], // or ['*']
  client: true,
  server: true
});
```

- `denyClient: true` — adapter only on server (client logs via Meteor method)
- `denyServer: true` — adapter only on client
- Filter matching is case-insensitive (`'error'` → `ERROR`)

### userId

`log.userId` is a `ReactiveVar`. Set with `log.userId.set(id)` for automatic inclusion.

### Circular references

Logger sanitizes circular objects in `data` before adapters receive them (`[Circular]`).

## Meteor 3

- Package `ostrio:logger` ≥ **2.2.0**
- Supported Meteor releases: **2.14, 2.15, 2.16, 3.2, 3.3.1, 3.4**
- In custom adapter `init`, use `new Mongo.Collection('name')` — not `Meteor.Collection`

## Testing locally

```bash
npm i -g @zodern/mtest
mtest --package ./ --once 3.4
```
