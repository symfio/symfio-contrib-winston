winston = require "winston"
path = require "path"


module.exports = (container) ->
  container.set "winston", ->
    winston

  container.set "loggerLevel", (env) ->
    switch env
      when "development"
        "silly"
      when "production"
        "warn"
      else
        "info"

  container.set "loggerFile", (name, applicationDirectory) ->
    path.join applicationDirectory, "#{name}.log"

  container.set "consoleLoggerConfiguration", (env, loggerLevel) ->
    level: loggerLevel
    colorize: env is "development"
    timestamp: true

  container.set "fileLoggerConfiguration", (loggerLevel, loggerFile) ->
    level: loggerLevel
    timestamp: true
    filename: loggerFile

  container.set "consoleLogger", (winston, consoleLoggerConfiguration) ->
    new winston.transports.Console consoleLoggerConfiguration

  container.set "fileLogger", (winston, fileLoggerConfiguration) ->
    new winston.transports.File fileLoggerConfiguration

  container.set "loggerTransports", (env, consoleLogger, fileLogger) ->
    switch env
      when "development"
        [consoleLogger]
      when "production"
        [fileLogger]
      when "test"
        []
      else
        [consoleLogger, fileLogger]

  container.set "loggerLevels", (winston) ->
    winston.config.npm.levels

  container.set "loggerColors", (winston) ->
    winston.config.npm.colors

  container.set "logger",
    (winston, loggerTransports, loggerLevels, loggerColors) ->
      winston.addColors loggerColors

      logger = new winston.Logger transports: loggerTransports
      logger.setLevels loggerLevels
      logger
