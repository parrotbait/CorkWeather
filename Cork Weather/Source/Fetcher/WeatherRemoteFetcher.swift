//
//  WeatherRemoteFetcher.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

struct WeatherRemoteFetcher : WeatherFetcherProtocol {
    
    private let key : String = "7befbe91c82feed9d53af306ca9deb64"
    private let weatherUrl : String =  "https://api.openweathermap.org/data/2.5/weather?q=%@&APPID=%@%@"
    
    public func fetch(location : String, unit : TemperatureUnit, completion: @escaping WeatherCallback){
        let unitStr = unit.rawValue.isEmpty ? "" : String(format: "&units=%@", unit.rawValue)
        let finalUrl : String = String(format:weatherUrl, location, key, unitStr)
        guard let url = URL(string: finalUrl) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if (error != nil) {
                completion(false, nil);
            } else {
                let parser = WeatherJsonParser();
                if let weather : Weather = parser.parse(jsonData: data! as NSData) {
                    
                    completion(true, weather);
                } else {
                    completion(false, nil);
                }
            }
        })
        task.resume()
    }
}
