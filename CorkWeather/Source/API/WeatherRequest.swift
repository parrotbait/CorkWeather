//
//  WeatherRequest.swift
//  CorkWeather
//
//  Created by Eddie Long on 26/06/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation

enum WeatherRequest: HTTPRequest {
    case forLocation(latitude: LocationDegrees, longitude:LocationDegrees, unit: TemperatureUnit)
    
    var path: String {
        switch self {
        case .forLocation:
            return "/weather"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .forLocation:
            return .get
        }
    }
    
    var query: [String : Any]? {
        switch self {
        case .forLocation(let latitude, let longitude, let unit):
            assert(!sharedConfig.weatherAPIKey.isEmpty, "Missing API key")
            return [
                "lat": "\(latitude)",
                "lon": "\(longitude)",
                "APPID": sharedConfig.weatherAPIKey,
                "units": unit.rawValue
            ]
        }
    }
    
    var postBody: HTTPPostData? {
        return nil
    }
    
    var headers: [String: Any]? {
        return nil
    }
}
