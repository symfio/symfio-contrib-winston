symfio = require "symfio"


container = symfio "example", __dirname

container.use require ".."
container.use (logger) ->
  for level in ["silly", "verbose", "debug", "info", "warn", "error"]
    logger.log level, "Example message"

container.load()
