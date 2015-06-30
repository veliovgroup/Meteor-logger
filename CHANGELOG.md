Changelog
=========
 - [[`v1.0.0`](https://github.com/VeliovGroup/Meteor-logger/releases/tag/v1.0.0)] *07/01/2015*
   - First argument now can be *String* or *Number*
   - Now `Meteor.log[type]` can be used with `throw`, and returns error details
 - [[`v0.0.8`](https://github.com/VeliovGroup/Meteor-logger/releases/tag/v0.0.8)] *06/07/2015*
   - Fix issue `TypeError: Cannot read property 'get' of undefined`
 - [[`v0.0.7`](https://github.com/VeliovGroup/Meteor-logger/releases/tag/v0.0.7)] *05/29/2015*
   - Fix issue with `userId.get is not a function`
   - Add Changelog.md
 - [[`v0.0.6`](https://github.com/VeliovGroup/Meteor-logger/releases/tag/v0.0.6)] *05/28/2015*
   - Fix issue [#2](VeliovGroup/Meteor-logger-file#2)
   - Remove colon from file names, to avoid Windows compilation issues
   - License update
 - [[`v0.0.5`](https://github.com/VeliovGroup/Meteor-logger/releases/tag/v0.0.5)] *05/25/2015*
   - Add support for `audit-argument-checks`
   - Move from `Sessions` to `ReactiveVar`
   - Fix issue with `undefined` `userId`
   - Packages update
 - [[`v0.0.4`](https://github.com/VeliovGroup/Meteor-logger/releases/tag/v0.0.4)] Initial, please see docs