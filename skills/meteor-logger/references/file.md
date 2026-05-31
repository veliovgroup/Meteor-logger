# ostrio:loggerfile

Writes logs to the filesystem (server). Client logs are sent to the server adapter via Meteor methods.

```js
import { Logger } from 'meteor/ostrio:logger';
import { LoggerFile } from 'meteor/ostrio:loggerfile';

const log = new Logger();
const fileAdapter = new LoggerFile(log, options);
fileAdapter.enable(rule);
```

## Constructor options

| Option | Description |
|--------|-------------|
| `path` | Log directory (prefer absolute in prod, e.g. `/data/logs`) |
| `debug` | Log resolved `path` after write test |
| `onError(error, context)` | `mkdir` / `writeTest` / `appendFile` failures |
| `fileNameFormat(time)` | `(Date) => string` — log file name |
| `format(time, level, message, data, userId)` | `(…) => string` — line written to file |

Defaults use `ostrio:meteor-root` for app path when `path` is omitted. Writes are queued until the directory passes a write test.

## enable(rule)

```js
fileAdapter.enable({
  enable: true,
  filter: ['*'],
  client: true,
  server: true
});
```

`enable: false` stops file writes while keeping the adapter registered.

## Server dependency

```js
meteor add ostrio:meteor-root  // used on server for default path
```

## Package

- `meteor add ostrio:loggerfile`
- Requires `ostrio:logger` (≥ 2.2.0 for Meteor 3)
