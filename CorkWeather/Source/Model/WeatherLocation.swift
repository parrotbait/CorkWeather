//
//  WeatherLocation.swift
//  Cork Weather
//
//  Created by Eddie Long on 10/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

struct WeatherLocation: Codable {
    var coordinate : WeatherCoordinate
    var addressLines: [String]?
    var postcode : String?
    
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case coordinate = "coord"
        case addressLines = "addressLines"
        case postcode = "postcode"
    }
}

extension WeatherLocation: Equatable {
    public static func == (lhs: WeatherLocation, rhs: WeatherLocation) -> Bool {
        return rhs.coordinate == lhs.coordinate &&
            lhs.addressLines == rhs.addressLines &&
            lhs.postcode == rhs.postcode
    }
}
