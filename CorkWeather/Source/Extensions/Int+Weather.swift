//
//  Int+Weather.swift
//  CorkWeather
//
//  Created by Eddie Long on 11/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation

extension Int {
    func getAsString(forUnit unit: TemperatureUnit) -> String {
        switch (unit) {
        case .celsius:
            return String(format: "%d °C", self)
        case .fahrenheit:
            return String(format: "%d °F", self)
        case .kelvin:
            return String(format: "%d °K", self)
        }
    }
}
