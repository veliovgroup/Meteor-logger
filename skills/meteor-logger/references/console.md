# ostrio:loggerconsole

Prints logs to the console with optional colors. Forwards client logs to the server console by default.

```js
import { Logger } from 'meteor/ostrio:logger';
import { LoggerConsole } from 'meteor/ostrio:loggerconsole';

const log = new Logger();
const consoleAdapter = new LoggerConsole(log, settings);
consoleAdapter.enable(rule);
```

## Constructor settings

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `highlight` | Boolean | `true` | ANSI on server, `%c`/CSS on client. `false` = plain text (CI, ELK, log shippers) |
| `format` | Function | — | `(opts) => string` — custom line format; `opts`: `level`, `message`, `data`, `userId`, `time` |

## enable(rule)

```js
consoleAdapter.enable({
  enable: true,
  filter: ['ERROR', 'FATAL'],
  client: true,
  server: true
});
```

Returns `this` (chainable).

## Patterns

**Server-only console:**

```js
new LoggerConsole(log).enable({ client: false, server: true });
```

**Plain logs (CI / Elasticsearch / Kibana):**

```js
new LoggerConsole(log, {
  highlight: false,
  format(opts) {
    return JSON.stringify({
      level: opts.level,
      message: opts.message,
      data: opts.data,
      userId: opts.userId,
      time: opts.time
    });
  }
}).enable();
```

## Package

- `meteor add ostrio:loggerconsole`
- Requires `ostrio:logger` (≥ 2.2.0 for Meteor 3)
