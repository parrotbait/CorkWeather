# SWLogger
A simple Swift Logger

WARNING: This pod is in active development, stable so far in all tests. 
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

Log levels available:

* Verbose (Log.v)
* Debug (Log.d)
* Info (Log.i)
* Warning (Log.w)
* Error (Log.e)

## Filtering messages

By default in release only warning messages are allowed though. In debug, debug messages are allowed.

Set the log level for the app to error (everything less than this will not be logged)
```
Log.setLevel(level: .error)
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

## Default File Handler

Provided is another example of a handle, the file handler which enables logging to disk.
When the handler is created a log file with a timestamp '2017-10-02-09-48-37995.log' is created in the Documents directory. Logs are written to this file as they arrive in. This log handler is NOT enabled by default. Example usage below;

```
Log.addHandler(DefaultFileHandler())
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

Or remove the log handler
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
