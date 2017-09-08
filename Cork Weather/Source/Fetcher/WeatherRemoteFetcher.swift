//
//  WeatherRemoteFetcher.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

struct WeatherRemoteFetcher : WeatherFetcherProtocol {
    
    private let key : String = ""
    private let weatherUrl : String =  "https://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&APPID=%@%@"
    
    public func fetch(location : WeatherLocation, unit : TemperatureUnit, completion: @escaping WeatherCallback){
        let unitStr = unit.rawValue.isEmpty ? "" : String(format: "&units=%@", unit.rawValue)
        let finalUrl : String = String(format:weatherUrl, location.coordinate.latitude, location.coordinate.longitude, key, unitStr)
        guard let url = URL(string: finalUrl) else {
            Log.e("Error: cannot create URL")
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
                if let weather : Weather = parser.parse(location: location, jsonData: data! as NSData) {
                    completion(true, weather);
                } else {
                    completion(false, nil);
                }
            }
        })
        task.resume()
    }
}
