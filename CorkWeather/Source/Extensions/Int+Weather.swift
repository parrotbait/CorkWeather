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
        case .Celsius:
            return String(format: "%d °C", self);
        case .Fahrenheit:
            return String(format: "%d °F", self);
        case .Kelvin:
            return String(format: "%d °K", self);
        }
    }
}
