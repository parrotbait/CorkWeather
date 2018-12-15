//
//  Config.swift
//  CorkWeather
//
//  Created by Eddie Long on 14/12/2018.
//  Copyright © 2018 eddielong. All rights reserved.
//

import Foundation

struct Config {
    
    // Parameter is the 'icon' returned by openweathermap
    // TODO: Don't substitute this at runtime, but do it when we've fetched records back from OWM
    let weatherImageBase = "https://openweathermap.org/img/w/%@.png"
    
    let weatherAPIKey : String
    
    init() {
        #if DEBUG
            guard let path = Bundle.main.path(forResource: "config", ofType: "plist") else {
                fatalError("Missing config.plist file")
            }
            let plist = NSDictionary.init(contentsOfFile: path)
            guard let api = plist?.object(forKey: "weather_api_key") else {
                fatalError("Missing weather_api_key in plist config file")
            }
            weatherAPIKey = api as! String
        #else
            weatherAPIKey = ""
        
        if weatherAPIKey.isEmpty {
            fatalError("Add weather API key above in distribution")
        }
        #endif
    }
    
    let twitterBio = "http://www.twitter.com/parrotbait"
    let feedbackEmailSubject = "Cork Weather App Feedback"
    let feedbackEmailRecipients = ["parrotbait@gmail.com"]
}

let sharedConfig = Config()
