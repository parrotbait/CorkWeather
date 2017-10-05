//
//  WeatherRemoteFetcher.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import SWLogger

struct WeatherRemoteFetcher : WeatherFetcherProtocol {
    
    private let useRandomDelay = false
    private let key : String = ""
    private let weatherUrl : String =  "https://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&APPID=%@%@"
    
    public func fetch(location : WeatherLocation, unit : TemperatureUnit, completion: @escaping WeatherCallback){
        let unitStr = unit.rawValue.isEmpty ? "" : String(format: "&units=%@", unit.rawValue)
        let finalUrl : String = String(format:weatherUrl, location.coordinate.latitude, location.coordinate.longitude, key, unitStr)
        
        if key.isEmpty {
            completion(Result.failure(WeatherLoadError.missingKey))
            return
        }
        
        guard let url = URL(string: finalUrl) else {
            Log.e("Error: cannot create URL")
            completion(Result.failure(WeatherLoadError.badUrl))
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if self.useRandomDelay {
                let randLower : UInt32 = 1
                let randUpper : UInt32 = 50
                let randDelayTime = arc4random_uniform(randUpper - randLower) + randLower
                let randDelayTimer = Double(randDelayTime) / 10
                Thread.sleep(forTimeInterval: randDelayTimer)
            }
            
            if (error != nil) {
                completion(Result.failure(WeatherLoadError.backendError));
            } else {
                let parser = WeatherJsonParser();
                if let weather : Weather = parser.parse(location: location, jsonData: data! as NSData) {
                    completion(Result.success(weather));
                } else {
                    completion(Result.failure(WeatherLoadError.parseError));
                }
            }
        })
        task.resume()
    }
}
