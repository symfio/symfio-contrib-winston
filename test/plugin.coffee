winston = require "winston"
symfio = require "symfio"
chai = require "chai"


describe "contrib-winston()", ->
  chai.use require "chai-as-promised"
  chai.should()

  container = symfio "test", __dirname

  before (callback) ->
    container.inject(require "..").should.notify callback

  it "should be configurable", (callback) ->
    container.get([
      "loggerLevel"
      "loggerFile"
      "consoleLoggerConfiguration"
      "fileLoggerConfiguration"
      "loggerTransports"
      "loggerLevels"
      "loggerColors"
    ]).then (result) ->
      result[0].should.equal "silly"
      result[1].should.match /\/test.log$/
      result[2].should.eql
        level: result[0]
        colorize: true
        timestamp: true
      result[3].should.eql
        level: result[0]
        timestamp: true
        filename: result[1]
      result[4].should.have.length 1
      result[5].should.equal winston.config.npm.levels
      result[6].should.equal winston.config.npm.colors
    .should.notify callback
