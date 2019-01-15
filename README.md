# Cork Weather

[Badge](https://build.appcenter.ms/v0.1/apps/e7027ca3-de06-426f-9af4-0d73431401b8/branches/master/badge)

This app is a bit of a fun/joke app created as a learning experience for myself

The app allows you to pick a Cork location on a map. When you pick a location the app does a reverse geocode on the latitude longitude to get the full address and also looks up the current weather for that location.

## Goals

Learn Swift and try out some iOS architectures and concepts.
High code coverage for tests.
Attempt to adhere to SRP as much as possible.
Prettiness is not a goal!

## Architecture

This app uses MVVM as the main architecture. I really wanted to keep the view controllers as small as possible.
The view controller does not know about the model Weather objects by design. It is all hidden away within the view model.  The table view data is driven by the view model data.
The view model doesn't explicitly know about the UI, in that it doesn't include UIKit. It does format strings for presentation purposes, I feel this is one of the short comings of the MVVM model in my opinion.
I feel that there should be another layer on top of the view model to massage any data for presentation purposes, but there's a balancing act of too many layers on top. If the UI became more complex and needed more complex UIKit operations then it is likely I would add in a separate presentor on top of the view model, similar to the Presentor in VIPER. 

Routing is done using the Coordinator pattern to decouple knowledge between different view controllers.
Dependencies are passed into the view model so they can be mocked, stubbed and tested. This has allowed me to have 100% test coverage of the view model. I do not use a formal dependency injection framework as I prefer to keep it as simple as possible.

The database layer is using Firebase, this is useful for cloud persistance. I may add Realm in future but I am not sure I want to take the size hit and have the Realm types invade on the app. 
For reverse geocoding I use Google Maps, this implementation could easily be swapped out in future.
For weather I'm using the OpenWeather API. 

The app does not include the API keys for OpenWeather or Google Maps in the repository, which is typically good practice. To add it in you have two options, add config.plist with `weather_api_key` and `google_places_api_key` or hard code it into the AppConfig.swift file. The config.plist file is not used in release, only debug. This is so people cannot check the bundle at runtime and scrape (and use) the api keys.

## TODO

* Improve UI
* Offline mode/testing
* Fastlane integration
* Documentation
* Add tap actions to see weather for the next few days
* General code cleanup

## Features

✓ MVVM architecture with coordinator for navigation.

✓ SwiftLint code checked

✓ 100% test code coverage of view models (and other parts of the app). Attempted to get as much code coverage as possible.

✓ Static cell identifiers (no strings)

✓ SWLogger - a cocoapod created as part of this exercise for logging

✓ OpenWeatherAPI integration for weather data fetching

✓ Google Maps and Places for picking of locations

✓ Localisation within a single storyboard via user defined runtime attributes and extensions

✓ Firebase database for record persistance, even between installs

✓ Analytics via Firebase

✓ Very simple intro/tutorial & info page

✓ Continuous integration with Microsoft Mobile Center (for CorkWeather + SWLogger)

