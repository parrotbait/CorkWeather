//
//  Config.swift
//  CorkWeather
//
//  Created by Eddie Long on 14/12/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation
import Proteus_Core

class AppConfig {
    
    // Parameter is the 'icon' returned by openweathermap
    // TODO: Don't substitute this at runtime, but do it when we've fetched records back from OWM
    let weatherImageBase = "https://openweathermap.org/img/w/%@.png"
    private let weatherUrl = "https://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&APPID=%@%@"
    
    static let defaultPickerCoordinate = WeatherCoordinate.init(latitude: 51.894981, longitude: -8.472618)
    static let defaultZoomSize = 0.04
    
    let weatherAPIKey : String
    let googleAPIKey: String
    
    let config = Config()
    
    init() {
        #if DEBUG
            self.weatherAPIKey = config.getKey(key: "weather_api_key")
            self.googleAPIKey = config.getKey(key: "google_places_api_key")
        #else
            weatherAPIKey = ""
            if weatherAPIKey.isEmpty {
                fatalError("Add weather API key above in distribution")
            }
            googleAPIKey = ""
            if googleAPIKey.isEmpty {
                fatalError("Add google places API key above in distribution")
            }
        #endif
    }
    
    typealias WeatherUrlResult = Result<String, WeatherLoadError>
    func getWeatherFetchUrl(latitude: LocationDegrees, longitude:LocationDegrees, unit: TemperatureUnit) -> WeatherUrlResult {
        if weatherAPIKey.isEmpty {
            return .failure(.missingKey)
        }
        let unitStr = unit.rawValue.isEmpty ? "" : String(format: "&units=%@", unit.rawValue)
        return .success(String(format:weatherUrl, latitude, longitude, weatherAPIKey, unitStr))
    }
    
    let twitterBio = "http://www.twitter.com/parrotbait"
    let feedbackEmailSubject = "Cork Weather App Feedback"
    let feedbackEmailRecipients = ["parrotbait@gmail.com"]
}

let sharedConfig = AppConfig()
