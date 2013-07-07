winston = require "winston"
suite = require "symfio-suite"


describe "contrib-winston()", ->
  it = suite.plugin [
    require ".."
  ]

  describe "container.unless loggerLevel", ->
    it "should be silly on development env", (container) ->
      container.set "env", "development"
      container.inject (loggerLevel) ->
        loggerLevel.should.equal "silly"

    it "should be warn on production env", (container) ->
      container.set "env", "production"
      container.inject (loggerLevel) ->
        loggerLevel.should.equal "warn"

    it "should be info otherwise", (loggerLevel) ->
      loggerLevel.should.equal "info"

  describe "container.unless loggerFile", ->
    it "should be name.log", (loggerFile) ->
      loggerFile.should.match /\/test\.log$/

  describe "container.unless consoleLoggerConfiguration", ->
    it "should be colorized on development env", (container) ->
      container.set "env", "development"
      container.inject (consoleLoggerConfiguration) ->
        consoleLoggerConfiguration.colorize.should.be.true

    it "should not be colorized otherwise", (consoleLoggerConfiguration) ->
      consoleLoggerConfiguration.colorize.should.be.false

    it "should have timestamp property", (consoleLoggerConfiguration) ->
      consoleLoggerConfiguration.timestamp.should.be.true

    it "should have level property",
      (consoleLoggerConfiguration, loggerLevel) ->
        consoleLoggerConfiguration.level.should.equal loggerLevel

  describe "container.unless fileLoggerConfiguration", ->
    it "should have timestamp property", (fileLoggerConfiguration) ->
      fileLoggerConfiguration.timestamp.should.be.true

    it "should have level property",
      (fileLoggerConfiguration, loggerLevel) ->
        fileLoggerConfiguration.level.should.equal loggerLevel

    it "should have filename property",
      (fileLoggerConfiguration, loggerFile) ->
        fileLoggerConfiguration.filename.should.equal loggerFile

  describe "container.unless loggerTransports", ->
    it "should have consoleLogger on development env", (container) ->
      container.set "env", "development"
      container.inject (loggerTransports) ->
        loggerTransports.should.have.length 1
        loggerTransports[0].name.should.equal "console"

    it "should have fileLogger on production env", (container) ->
      container.set "env", "production"
      container.inject (loggerTransports) ->
        loggerTransports.should.have.length 1
        loggerTransports[0].name.should.equal "file"

    it "should have no logger on test env", (loggerTransports) ->
      loggerTransports.should.have.length 0

    it "should have all loggers otherwise", (container) ->
      container.set "env", "otherwise"
      container.inject (loggerTransports) ->
        loggerTransports.should.have.length 2
        loggerTransports[0].name.should.equal "console"
        loggerTransports[1].name.should.equal "file"

  describe "container.unless loggerLevels", ->
    it "should equal winston.config.npm.levels", (loggerLevels) ->
      loggerLevels.should.equal winston.config.npm.levels
  
  describe "container.unless loggerColors", ->
    it "should equal winston.config.npm.colors", (loggerColors) ->
      loggerColors.should.equal winston.config.npm.colors
