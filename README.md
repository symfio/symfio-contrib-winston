# symfio-contrib-winston

> Winston plugin for Symfio.

[![Build Status](https://travis-ci.org/symfio/symfio-contrib-winston.png?branch=master)](https://travis-ci.org/symfio/symfio-contrib-winston) [![Dependency Status](https://gemnasium.com/symfio/symfio-contrib-winston.png)](https://gemnasium.com/symfio/symfio-contrib-winston)

## Usage

```coffee
symfio = require "symfio"

container = symfio "example", __dirname

container.inject require "symfio-contrib-winston"

container.inject (logger) ->
  logger.info "Info message"
```

## Configuration

### `loggerLevel`

Default value depends on `env`.

### `loggerFile`

Default value is `#{name}.log`.

### `consoleLoggerConfiguration`

[Console Transport](https://github.com/flatiron/winston/blob/master/docs/transports.md#console-transport)
configuration.

### `fileLoggerConfiguration`

[File Transport](https://github.com/flatiron/winston/blob/master/docs/transports.md#file-transport)
configuration.

### `loggerTransports`

Array with transports to use. Default value depends on `env`.

### `loggerLevels`

Array with levels. Default is `winston.config.npm.levels`.

### `loggerColors`

Array with level colors. Default is `winston.config.npm.colors`.

## Services

### `winston`

Original `winston` module.

### `consoleLogger`

Console Transport instance.

### `fileLogger`

File Transport instance.

### `logger`

Configured logger instance.
