//
//  WeatherFetcher.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

struct WeatherFetcher : WeatherFetcherProtocol {
    enum FetcherType {
        case remote (WeatherRemoteFetcher)
        case local (WeatherLocalFetcher)
    }
    
    public var fetchType : FetcherType = .remote (WeatherRemoteFetcher())
    
    public func fetch(location : WeatherLocation, unit : TemperatureUnit, completion: @escaping WeatherFetcherProtocol.WeatherCallback) {
        switch fetchType {
        case .remote(let fetcher):
            fetcher.fetch(location: location, unit: unit, completion: completion)
        case .local(let fetcher):
            fetcher.fetch(location: location, unit: unit, completion: completion)
        }
    }
}
