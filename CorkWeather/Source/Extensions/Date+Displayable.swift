//
//  Date+Displayable.swift
//  CorkWeather
//
//  Created by Eddie Long on 04/10/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

extension Date {
    static let weatherDateFormatter = DateFormatter()
    func weatherDateString() -> String {
        let formatRequired = "HH:mm dd MMM yyyy"
        Date.weatherDateFormatter.dateFormat = formatRequired
        return Date.weatherDateFormatter.string(from: self)

    }
}
