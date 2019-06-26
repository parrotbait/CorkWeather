//
//  Int+Weather.swift
//  CorkWeather
//
//  Created by Eddie Long on 11/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation

extension Double {
    func getAsString(forUnit unit: TemperatureUnit) -> String {
        switch (unit) {
        case .celsius:
            return String(format: "%0.1f °C", self)
        case .fahrenheit:
            return String(format: "%0.1f °F", self)
        case .kelvin:
            return String(format: "%0.1f °K", self)
        }
    }
}
