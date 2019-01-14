//
//  WeatherRemoteFetcher.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import SWLogger
import Proteus_Core

struct WeatherRemoteFetcher : WeatherFetcherProtocol {
    
    private let useRandomDelay = false
    
    public func fetch(location : WeatherLocation, unit : TemperatureUnit, completion: @escaping WeatherCallback) {
        
        let result = sharedConfig.getWeatherFetchUrl(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, unit: unit)
        var finalUrl = ""
        switch (result) {
        case .success(let url):
            finalUrl = url
        case .failure(let error):
            completion(.failure(error))
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
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, _, error) in
            if self.useRandomDelay {
                let randLower : UInt32 = 1
                let randUpper : UInt32 = 50
                let randDelayTime = arc4random_uniform(randUpper - randLower) + randLower
                let randDelayTimer = Double(randDelayTime) / 10
                Thread.sleep(forTimeInterval: randDelayTimer)
            }
            
            if (error != nil) {
                completion(Result.failure(WeatherLoadError.backendError))
            } else {
                let parser = WeatherJsonParser()
                if let weather : Weather = parser.parse(location: location, jsonData: data! as NSData) {
                    completion(Result.success(weather))
                } else {
                    completion(Result.failure(WeatherLoadError.parseError))
                }
            }
        })
        task.resume()
    }
}
