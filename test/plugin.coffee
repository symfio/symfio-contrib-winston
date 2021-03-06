suite = require "symfio-suite"


describe "contrib-winston()", ->
  it = suite.plugin (container) ->
    container.inject ["suite/container"], require ".."
    container.require "path"
    container.set "applicationDirectory", "/"
    container.set "loggerLevel", "silly"
    container.set "loggerFile", "/test.log"
    container.set "consoleLoggerConfiguration", "consoleConfiguration"
    container.set "fileLoggerConfiguration", "fileConfiguration"
    container.set "consoleLogger", "console"
    container.set "fileLogger", "file"
    container.set "loggerTransports", ["file"]
    container.set "loggerLevels", ["debug"]
    container.set "loggerColors", debug: "red"
    container.set "winston", (sandbox) ->
      config: npm:
        levels: "levels"
        colors: "colors"
      transports:
        Console: sandbox.spy()
        File: sandbox.spy()
      Logger: sandbox.spy()

  describe "container.set path", ->
    it "should be setted", (setted) ->
      setted "path"

  describe "container.set winston", ->
    it "should be setted", (setted) ->
      setted "winston"

  describe "container.unless loggerLevel", ->
    it "should be silly on development env", (unlessed) ->
      factory = unlessed "loggerLevel"
      factory.dependencies.env = "development"
      factory().should.eventually.equal "silly"

    it "should be warn on production env", (unlessed) ->
      factory = unlessed "loggerLevel"
      factory.dependencies.env = "production"
      factory().should.eventually.equal "warn"

    it "should be info otherwise", (unlessed) ->
      factory = unlessed "loggerLevel"
      factory().should.eventually.equal "info"

  describe "container.unless loggerFile", ->
    it "should be name.log", (unlessed) ->
      factory = unlessed "loggerFile"
      factory().should.eventually.equal "/test.log"

  describe "container.unless consoleLoggerConfiguration", ->
    it "should be colorized on development env", (unlessed) ->
      factory = unlessed "consoleLoggerConfiguration"
      factory.dependencies.env = "development"
      factory().then (consoleLoggerConfiguration) ->
        consoleLoggerConfiguration.colorize.should.be.true

    it "should not be colorized otherwise", (unlessed) ->
      factory = unlessed "consoleLoggerConfiguration"
      factory().then (consoleLoggerConfiguration) ->
        consoleLoggerConfiguration.colorize.should.be.false

    it "should have timestamp property", (unlessed) ->
      factory = unlessed "consoleLoggerConfiguration"
      factory().then (consoleLoggerConfiguration) ->
        consoleLoggerConfiguration.timestamp.should.be.true

    it "should have level property", (unlessed) ->
      factory = unlessed "consoleLoggerConfiguration"
      factory().then (consoleLoggerConfiguration) ->
        loggerLevel = factory.dependencies.loggerLevel
        consoleLoggerConfiguration.level.should.equal loggerLevel

  describe "container.unless fileLoggerConfiguration", ->
    it "should have timestamp property", (unlessed) ->
      factory = unlessed "fileLoggerConfiguration"
      factory().then (fileLoggerConfiguration) ->
        fileLoggerConfiguration.timestamp.should.be.true

    it "should have level property", (unlessed) ->
      factory = unlessed "fileLoggerConfiguration"
      factory().then (fileLoggerConfiguration) ->
        loggerLevel = factory.dependencies.loggerLevel
        fileLoggerConfiguration.level.should.equal loggerLevel

    it "should have filename property", (unlessed) ->
      factory = unlessed "fileLoggerConfiguration"
      factory().then (fileLoggerConfiguration) ->
        loggerFile = factory.dependencies.loggerFile
        fileLoggerConfiguration.filename.should.equal loggerFile

  describe "container.unless loggerTransports", ->
    it "should have consoleLogger on development env", (unlessed) ->
      factory = unlessed "loggerTransports"
      factory.dependencies.env = "development"
      factory().then (loggerTransports) ->
        loggerTransports.should.have.length 1
        loggerTransports[0].should.equal "console"

    it "should have fileLogger on production env", (unlessed) ->
      factory = unlessed "loggerTransports"
      factory.dependencies.env = "production"
      factory().then (loggerTransports) ->
        loggerTransports.should.have.length 1
        loggerTransports[0].should.equal "file"

    it "should have no logger on test env", (unlessed) ->
      factory = unlessed "loggerTransports"
      factory().then (loggerTransports) ->
        loggerTransports.should.have.length 0

    it "should have all loggers otherwise", (unlessed) ->
      factory = unlessed "loggerTransports"
      factory.dependencies.env = "unknown"
      factory().then (loggerTransports) ->
        loggerTransports.should.have.length 2
        loggerTransports[0].should.equal "console"
        loggerTransports[1].should.equal "file"

  describe "container.unless loggerLevels", ->
    it "should equal winston.config.npm.levels", (unlessed) ->
      factory = unlessed "loggerLevels"
      factory().then (loggerLevels) ->
        loggerLevels.should.equal factory.dependencies.winston.config.npm.levels

  describe "container.unless loggerColors", ->
    it "should equal winston.config.npm.colors", (unlessed) ->
      factory = unlessed "loggerColors"
      factory().then (loggerColors) ->
        loggerColors.should.equal factory.dependencies.winston.config.npm.colors

  describe "container.set consoleLogger", ->
    it "should create transport", (setted, winston) ->
      factory = setted "consoleLogger"
      factory().then ->
        winston.transports.Console.should.be.calledWithNew
        winston.transports.Console.should.be.calledWith "consoleConfiguration"

  describe "container.set fileLogger", ->
    it "should create transport", (setted, winston) ->
      factory = setted "fileLogger"
      factory().then ->
        winston.transports.File.should.be.calledWithNew
        winston.transports.File.should.be.calledWith "fileConfiguration"

  describe "container.set logger", ->
    it "should create transport", (setted, winston) ->
      factory = setted "logger"
      factory().then ->
        winston.Logger.should.be.calledWithNew
        winston.Logger.should.be.calledWith
          transports: ["file"]
          levels: ["debug"]
          stripColors: true
          colors: debug: "red"
