//
//  WeatherLoadError.swift
//  Cork Weather
//
//  Created by Eddie Long on 05/09/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

enum WeatherLoadError : Error {
    case backendError
    case parseError
}
