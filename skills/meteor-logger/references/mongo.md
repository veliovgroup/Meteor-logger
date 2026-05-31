# ostrio:loggermongo

Persists logs in MongoDB on the server. Client logs are forwarded via Meteor methods.

```js
import { Mongo } from 'meteor/mongo';
import { Logger } from 'meteor/ostrio:logger';
import { LoggerMongo } from 'meteor/ostrio:loggermongo';

const log = new Logger();
const mongoAdapter = new LoggerMongo(log, options);
mongoAdapter.enable(rule);
```

## Constructor options

| Option | Description |
|--------|-------------|
| `collectionName` | String — creates `new Mongo.Collection(name)` on server (default: `ostrioMongoLogger`) |
| `collection` | Existing `Mongo.Collection` instance (takes priority over `collectionName`) |
| `format` | `(opts) => plainObject` — shape stored document; must return a plain object |

`opts` fields: `userId`, `date`, `timestamp`, `level`, `message`, `additional` (data).

Default `format` returns `opts` as-is. Non-object return throws `Meteor.Error(400, ...)`.

On the server, Meteor 3+ uses `insertAsync()` via `Meteor.wrapAsync` so each log line is persisted before `_log` returns; Meteor 2.x uses sync `collection.insert()`.

## enable(rule)

```js
mongoAdapter.enable({
  enable: true,
  filter: ['ERROR', 'WARN'],
  client: true,
  server: true
});
```

## Custom collection

```js
const appLogs = new Mongo.Collection('appLogs');
new LoggerMongo(log, { collection: appLogs }).enable();
```

## Meteor 3 migration

Use **`Mongo.Collection`**, not `Meteor.Collection` (removed in Meteor 3). The adapter creates collections with `Mongo.Collection` internally.

## Package

- `meteor add ostrio:loggermongo`
- Requires `mongo` package on server
- Requires `ostrio:logger` (≥ 2.2.0 for Meteor 3)
