# SWLogger
A simple Swift Logger
WARNING: This is pretty early in development, stable so far in all tests. 
See TODO section for more.

# Features

* Log levels per log
* Tagging per log
* Tag filters
* Log file and function source of log message
* Global filtering of logs by log level
* Eaay to hook in to receive and process logs

# Usage

Log a debug mesaage
```
Log.d("My log")
```

Log an error message
```
Log.e("My error log")
```

Log a message with a specific tag
```
Log.i("My message", "TAG")
```

Log a message with custom extra data
```
Log.i("My message", "TAG", extra:123)
```

## Filtering messages

Set the log level for the app to warning (everything less than this will not be logged)
```
Log.setLevel(level: .warning)
```

Filter logs by tag(s)
```
Log.setTagFilters(tags: ["MainVC"])
```

## Default Log Handler

There is a build in log handler already in place with sensible defaults.
This can be customised somewhat, if you need significant different behaviour then it is recommended that you implement your own handler and disable the default handler.

Log file where the message was logged (including line number) e.g. MainViewController.swift:70
```
DefaultLogHandler.logFileDetails(true)
```

Log functions where the message was logged e.g. tableView(_:cellForRowAt:)
```
DefaultLogHandler.logFunc(true)
```

## Implement a custom handler

```
class MyLogHandler : LogHandler {
	public func logMessage(log: LogLine, tag: String, level: LogLevel) {
          // log.extra is available to use in any way desired. NSNull by default
    }
}
```

Register the log handler

```
Log.addHandler(MyLogHandler())
```

Or remove the log handler (TODO: Implement this)
```
Log.removeHandler(handler)
```

Disable the default log handler if you want to handle all logs yourself
```
Log.enableDefaultLogHandler = false
```

## TODO

* Thread safety
* Add tests
