winston = require "winston"
suite = require "symfio-suite"


describe "contrib-winston()", ->
  it = suite.plugin (containerStub) ->
    require("..") containerStub
    null

  describe "container.unless loggerLevel", ->
    it "should be silly on development env", (containerStub) ->
      factory = containerStub.unless.get "loggerLevel"
      factory("development").should.equal "silly"

    it "should be warn on production env", (containerStub) ->
      factory = containerStub.unless.get "loggerLevel"
      factory("production").should.equal "warn"

    it "should be info otherwise", (containerStub) ->
      factory = containerStub.unless.get "loggerLevel"
      factory("").should.equal "info"

  describe "container.unless loggerFile", ->
    it "should be name.log", (containerStub) ->
      factory = containerStub.unless.get "loggerFile"
      factory("test", "/").should.equal "/test.log"

  describe "container.unless consoleLoggerConfiguration", ->
    it "should be colorized on development env", (containerStub) ->
      factory = containerStub.unless.get "consoleLoggerConfiguration"
      factory("development", "silly").colorize.should.be.true

    it "should not be colorized otherwise", (containerStub) ->
      factory = containerStub.unless.get "consoleLoggerConfiguration"
      factory("test", "silly").colorize.should.be.false

    it "should have timestamp property", (containerStub) ->
      factory = containerStub.unless.get "consoleLoggerConfiguration"
      factory("test", "silly").timestamp.should.be.true

    it "should have level property", (containerStub) ->
      factory = containerStub.unless.get "consoleLoggerConfiguration"
      factory("test", "silly").level.should.equal "silly"

  describe "container.unless fileLoggerConfiguration", ->
    it "should have timestamp property", (containerStub) ->
      factory = containerStub.unless.get "fileLoggerConfiguration"
      factory("silly", "test.log").timestamp.should.be.true

    it "should have level property", (containerStub) ->
      factory = containerStub.unless.get "fileLoggerConfiguration"
      factory("silly", "test.log").level.should.equal "silly"

    it "should have filename property", (containerStub) ->
      factory = containerStub.unless.get "fileLoggerConfiguration"
      factory("silly", "test.log").filename.should.equal "test.log"

  describe "container.unless loggerTransports", ->
    it "should have consoleLogger on development env", (containerStub) ->
      factory = containerStub.unless.get "loggerTransports"
      loggerTransports = factory "development", "console", "file"
      loggerTransports.should.have.length 1
      loggerTransports[0].should.equal "console"

    it "should have fileLogger on production env", (containerStub) ->
      factory = containerStub.unless.get "loggerTransports"
      loggerTransports = factory "production", "console", "file"
      loggerTransports.should.have.length 1
      loggerTransports[0].should.equal "file"

    it "should have no logger on test env", (containerStub) ->
      factory = containerStub.unless.get "loggerTransports"
      loggerTransports = factory "test", "console", "file"
      loggerTransports.should.have.length 0

    it "should have all loggers otherwise", (containerStub) ->
      factory = containerStub.unless.get "loggerTransports"
      loggerTransports = factory "otherwise", "console", "file"
      loggerTransports.should.have.length 2
      loggerTransports[0].should.equal "console"
      loggerTransports[1].should.equal "file"

  describe "container.unless loggerLevels", ->
    it "should equal winston.config.npm.levels", (containerStub) ->
      factory = containerStub.unless.get "loggerLevels"
      factory(winston).should.equal winston.config.npm.levels

  describe "container.unless loggerColors", ->
    it "should equal winston.config.npm.colors", (containerStub) ->
      factory = containerStub.unless.get "loggerColors"
      factory(winston).should.equal winston.config.npm.colors
