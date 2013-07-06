winston = require "winston"
suite = require "symfio-suite"


describe "contrib-winston()", ->
  it = suite.plugin [
    require ".."
  ]

  it "should be configurable", (container) ->
    container.set "env", "development"

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
