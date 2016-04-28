_inst = 0
###
@class Logger
@summary Extend-able Logger class
###
class Logger
  userId: new ReactiveVar null
  constructor: ->
    @prefix = ++_inst
    if Meteor.isClient
      self = @
      if Package?['accounts-base']
        Tracker.autorun ->
          self.userId.set Meteor.userId()
    @_emitters = []
    @_rules = {}

  ###
  @memberOf Logger
  @name _log
  @param level    {String} - Log level Accepts 'ERROR', 'FATAL', 'WARN', 'DEBUG', 'INFO', 'TRACE', 'LOG' and '*'
  @param message  {String} - Text human-readable message
  @param data     {Object} - [optional] Any additional info as object
  @param userId   {String} - [optional] Current user id
  @summary Pass log's data to Server or/and Client
  ###
  _log: (level, message, data = {}, user) =>
    uid = user or @userId.get()
    for i, em of @_emitters
      if @_rules[em.name] and @_rules[em.name].allow.indexOf('*') isnt -1 or @_rules[em.name] and @_rules[em.name].allow.indexOf(level) isnt -1

        if level is "TRACE"
          if _.isString data
            _data = data
            data = {data: _data}
          data.stackTrace = @_getStackTrace()

        if Meteor.isClient and em.denyClient is true
          Meteor.call em.method, level, message, data, uid
        else if @_rules[em.name].client is true and @_rules[em.name].server is true and em.denyClient is false
          em.emitter level, message, data, uid
          if Meteor.isClient
            Meteor.call em.method, level, message, data, uid
        else if Meteor.isClient and @_rules[em.name].client is false and @_rules[em.name].server is true
          Meteor.call em.method, level, message, data, uid
        else
          em.emitter level, message, data, uid
          
    return new @_message
      level: level
      error: level
      reason: message
      errorType: level
      message: message
      details: data
      data: data
      user: uid
      userId: uid

  ###
  @memberOf Logger
  @name _message
  @class LoggerMessage
  @param data {Object}
  @summary Construct message object, ready to be thrown and stringified
  ###
  _message: class LoggerMessage
    constructor: (data) ->
      {@level, @error, @reason, @message, @details, @data, @user, @userId} = data
      @toString = -> "[#{@reason}] \r\nLevel: #{@level}; \r\nDetails: #{JSON.stringify(Logger::antiCircular(@data))}; \r\nUserId: #{@userId};"

  ###
  @memberOf Logger
  @name rule
  @param name    {String} - Adapter name
  @param options {Object} - Settings object, accepts next properties:
            enable {Boolean} - Enable/disable adapter
            filter {Array}   - Array of strings, accepts: 
                               'ERROR', 'FATAL', 'WARN', 'DEBUG', 'INFO', 'TRACE', 'LOG' and '*'
                               in lowercase or uppercase
                               default: ['*'] - Accept all
            client {Boolean} - Allow execution on Client
            server {Boolean} - Allow execution on Server
  @summary Enable/disable adapter and set it's settings
  ###
  rule: (name, options) =>
    if !name or !options or !options.enable
      throw new Meteor.Error '500', '"name", "options" and "options.enable" is require on Logger.rule(), when creating rule for "' + name + '"'

    if options.allow
      for k of options.allow
        options.allow[k] = options.allow[k].toUpperCase()

    @_rules[name] = 
      enable: options.enable
      allow: if options.allow || options.filter then options.allow || options.filter else ['*']
      client: if options.client then options.client else false
      server: if options.server then options.server else true
    return

  ###
  @memberOf Logger
  @name add
  @param name        {String}    - Adapter name
  @param emitter     {Function}  - Function called on Meteor.log...
  @param init        {Function}  - Adapter initialization function
  @param denyClient  {Boolean}   - Strictly deny execution on client, only pass via Meteor.methods
  @summary Register new adapter to be used within ostrio:logger package
  ###
  add: (name, emitter, init, denyClient = false) =>
    init and init()
    @_emitters.push
      name: name
      emitter: emitter
      method: "#{@prefix}_logger_emit_#{name}"
      denyClient: denyClient

    if Meteor.isServer
      method = {}
      method["#{@prefix}_logger_emit_#{name}"] = (level, message, data, userId) ->
        check level, String
        check message, Match.Optional Match.OneOf Number, String, null
        check data, Match.Optional Match.OneOf String, Object, null
        check userId, Match.Optional Match.OneOf String, null
        emitter level, message, data, (userId or @userId)
      Meteor.methods method
    return

  ###
  @memberOf Logger
  @name info; debug; error; fatal; warn; trace; _
  @param message {String} - Any text message
  @param data    {Object} - [optional] Any additional info as object
  @param userId  {String} - [optional] Current user id
  @summary Functions below is shortcuts for _log() method
  ###
  info: (message, data, userId) -> @_log "INFO", message, data, userId
  debug: (message, data, userId) -> @_log "DEBUG", message, data, userId
  error: (message, data, userId) -> @_log "ERROR", message, data, userId
  fatal: (message, data, userId) -> @_log "FATAL", message, data, userId
  warn: (message, data, userId) -> @_log "WARN", message, data, userId
  trace: (message, data, userId) -> @_log "TRACE", message, data, userId
  log: (message, data, userId) -> @_log "LOG", message, data, userId
  _: (message, data, userId) -> @_log "LOG", message, data, userId

  ###
  @memberOf Logger
  @name antiCircular
  @param data {Object} - Circular or any other object which needs to be non-circular
  ###
  antiCircular: (obj) ->
    _cache = [];
    _wrap = (obj) ->
      for v, k of obj
        if typeof v is "object" and v isnt null
          if _cache.indexOf(v) isnt -1
            obj[k] = "[Circular]"
            return undefined
          _cache.push v
          return _wrap v
    _wrap obj
    return obj

  ###
  @memberOf Logger
  @name _getStackTrace
  @summary Prepare stack trace message
  ###
  _getStackTrace: ->
    obj = {}
    Error.captureStackTrace obj, @_getStackTrace
    return obj.stack