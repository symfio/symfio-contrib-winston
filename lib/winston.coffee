module.exports = (container) ->
  # manual require without logger to prevent cyclic dependency winston<->logger
  container.set "path", ->
    require "path"

  container.set "winston", ->
    require "winston"

  container.unless "loggerLevel", (env) ->
    switch env
      when "development"
        "silly"
      when "production"
        "warn"
      else
        "info"

  container.unless "loggerFile", (name, path, applicationDirectory) ->
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
