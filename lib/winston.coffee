path = require "path"


module.exports = (container) ->
  container.unless "loggerLevel", (env) ->
    switch env
      when "development"
        "silly"
      when "production"
        "warn"
      else
        "info"

  container.unless "loggerFile", (name, applicationDirectory) ->
    path.join applicationDirectory, "#{name}.log"

  container.unless "consoleLoggerConfiguration", (env, loggerLevel) ->
    level: loggerLevel
    colorize: env is "development"
    timestamp: true

  container.unless "fileLoggerConfiguration", (loggerLevel, loggerFile) ->
    level: loggerLevel
    timestamp: true
    filename: loggerFile

  container.unless "loggerTransports", (env, consoleLogger, fileLogger) ->
    switch env
      when "development"
        [consoleLogger]
      when "production"
        [fileLogger]
      when "test"
        []
      else
        [consoleLogger, fileLogger]

  container.unless "loggerLevels", (winston) ->
    winston.config.npm.levels

  container.unless "loggerColors", (winston) ->
    winston.config.npm.colors

  container.set "winston", ->
    require "winston"

  container.set "consoleLogger", (winston, consoleLoggerConfiguration) ->
    new winston.transports.Console consoleLoggerConfiguration

  container.set "fileLogger", (winston, fileLoggerConfiguration) ->
    new winston.transports.File fileLoggerConfiguration

  container.set "logger",
    (winston, loggerTransports, loggerLevels, loggerColors) ->
      new winston.Logger
        transports: loggerTransports
        levels: loggerLevels
        stripColors: true
        colors: loggerColors
