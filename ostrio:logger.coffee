if Meteor.isClient
  Session.set "ostrioLoggerUserId", Meteor.userId()

class Logger

  constructor: () ->
    undefined

  _emitters: []
  _rules: {}

  log: (level, message, data) -> 
    for i, em of Logger::_emitters
      if Logger::_rules[em.name] and Logger::_rules[em.name].allow.indexOf('*') isnt -1 or Logger::_rules[em.name] and Logger::_rules[em.name].allow.indexOf(level) isnt -1
          
        if typeof userId == "undefined" or !userId
          userId = this.userId

        userId = if Meteor.isClient then Session.get("ostrioLoggerUserId") else userId

        if Meteor.isClient and em.denyClient is true
          Meteor.call em.method, level, message, data, userId
          undefined
        else if Logger::_rules[em.name].client is true and Logger::_rules[em.name].server is true and em.denyClient is false
          em.emitter level, message, data, userId
          if Meteor.isClient
            Meteor.call em.method, level, message, data, userId
            undefined
        else if Meteor.isClient and Logger::_rules[em.name].client is false and Logger::_rules[em.name].server is true
          Meteor.call em.method, level, message, data, userId
          undefined
        else
          em.emitter level, message, data, userId

  rule: (name, options) ->
    if !name or !options or !options.enable
      throw new Meteor.Error '500', '"name", "options" and "options.enable" is require on Meteor.log.rule(), when creating rule for "' + name + '"'

    if options.allow
      for k of options.allow
        options.allow[k] = options.allow[k].toUpperCase()

    Logger::_rules[name] = 
      enable: options.enable
      allow: if options.allow || options.filter then options.allow || options.filter else ['*']
      client: if options.client then options.client else false
      server: if options.server then options.server else true

  add: (name, emitter, init, denyClient = false) ->
    init and init()

    Logger::_emitters.push
      name: name
      emitter: emitter
      method: "logger_emit_#{name}"
      denyClient: denyClient

    if Meteor.isServer
      methFunc = {}
      methFunc["logger_emit_#{name}"] = (level, message, data) =>
        emitter level, message, data
      
      Meteor.methods methFunc

  info: (message, data, userId) ->
    @log "INFO", message, data, userId

  debug: (message, data, userId) ->
    @log "DEBUG", message, data, userId

  error: (message, data, userId) ->
    @log "ERROR", message, data, userId

  fatal: (message, data, userId) ->
    @log "FATAL", message, data, userId

  warn: (message, data, userId) ->
    @log "WARN", message, data, userId

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

Meteor.log = new Logger()