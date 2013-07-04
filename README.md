# symfio-contrib-winston

> Logger plugin.

[![Build Status](http://teamcity.rithis.com/httpAuth/app/rest/builds/buildType:id:bt20,branch:master/statusIcon?guest=1)](http://teamcity.rithis.com/viewType.html?buildTypeId=bt20&guest=1)
[![Dependency Status](https://gemnasium.com/symfio/symfio-contrib-winston.png)](https://gemnasium.com/symfio/symfio-contrib-winston)

## Usage

```coffee
symfio = require "symfio"

container = symfio "example", __dirname

container.use require "symfio-contrib-winston"

container.use (logger) ->
  logger.info "Info message"

container.load()
```
