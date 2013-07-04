symfio = require "symfio"

container = symfio "example", __dirname

container.inject(require "..").then ->
  container.inject (logger) ->
    for level in ["silly", "verbose", "debug", "info", "warn", "error"]
      logger.log level, "Example message"
