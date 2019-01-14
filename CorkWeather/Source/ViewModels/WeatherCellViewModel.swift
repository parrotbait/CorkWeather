//
//  WeatherCellViewModel.swift
//  CorkWeather
//
//  Created by Eddie Long on 14/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation
import Proteus_Core

class WeatherCellViewModel {
    let weatherItem: Weather
    let desiredUnit: TemperatureUnit
    
    init(_ unit: TemperatureUnit, weather: Weather) {
        desiredUnit = unit
        weatherItem = weather
    }
    
    var description : String {
        return weatherItem.description
    }
    
    var icon: String {
        return weatherItem.icon
    }
    
    var locationText: String {
        return weatherItem.location.addressLines.flatMap({$0})?.joined(separator: ", ") ?? ""
    }
    
    var temperature: String {
        return String(format: "%@", weatherItem.temperature.getAsString(forUnit: desiredUnit))
    }
    
    var maxTemperature: String {
        return String(format: Strings.get("Max_Temp"), weatherItem.maxTemperature.getAsString(forUnit: desiredUnit))
    }
    
    var windSpeed: String {
        return String(format: Strings.get("Wind_Speed"), weatherItem.windSpeed)
    }
    
    var date: String {
        return weatherItem.updateDate.weatherDateString()
    }
}
