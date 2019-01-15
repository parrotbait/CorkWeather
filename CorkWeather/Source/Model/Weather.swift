//
//  Weather.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import CoreLocation

public typealias WeatherID = Int
public typealias WeatherTemperature = Int
public typealias WindSpeed = Double

struct Weather {
    var description : String; // Weather condition within the group
    var icon : String; // Weather icon id
    var id : WeatherID; // Weather condition id
    var main : String; // Group of weather parameters (Rain, Snow, Extreme etc.)
    var temperature : WeatherTemperature; // Celsius
    var maxTemperature : WeatherTemperature; // Celsius
    var minTemperature : WeatherTemperature; // Celsius
    var windSpeed : WindSpeed; // m/s
    var location : WeatherLocation; // Longitude and latitude
    var updateDate : Date; // The date the weather was last updated
    
    private static let idKey = "id"
    private static let descriptionKey = "description"
    private static let iconKey = "icon"
    private static let mainKey = "main"
    private static let temperatureKey = "temperature"
    private static let temperatureMinKey = "min_temperature"
    private static let temperatureMaxKey = "max_temperature"
    private static let windSpeedKey = "wind_speed"
    private static let postcodeKey = "postcode"
    private static let latitudeKey = "latitude"
    private static let longitudeKey = "longitude"
    private static let addressLinesKey = "address_lines"
    private static let updateDateKey = "update_date"
    private static let invalidValueInt = -1
    private static let invalidValueDouble = -1.0
    
    public func toArray() -> [String: Any] {
    return [
        Weather.descriptionKey: description,
        Weather.iconKey : icon,
        Weather.idKey : id,
        Weather.mainKey : main,
        Weather.temperatureKey : temperature,
        Weather.temperatureMaxKey : maxTemperature,
        Weather.temperatureMinKey : minTemperature,
        Weather.windSpeedKey : windSpeed,
        Weather.postcodeKey : location.postcode ?? "",
        Weather.longitudeKey : location.coordinate.longitude,
        Weather.latitudeKey : location.coordinate.latitude,
        Weather.addressLinesKey : location.addressLines ?? "",
        Weather.updateDateKey : updateDate.timeIntervalSince1970
        ]
    }
    
    public static func fromArray(source : [String: Any]) -> Weather? {
        if let latitude = source[latitudeKey] as? Double,
            let longitude = source[longitudeKey] as? Double,
            let description = source[descriptionKey] as? String,
            let icon = source[iconKey] as? String,
            let id = source[idKey] as? WeatherID,
            let main = source[mainKey] as? String,
            let temp = source[temperatureKey] as? WeatherTemperature {
            let coords = WeatherCoordinate(latitude: latitude, longitude: longitude)
            let location = WeatherLocation.init(coordinate: coords, addressLines: source[addressLinesKey] as? [String], postcode: source[postcodeKey] as? String)
            return Weather.init(
                description: description,
                icon: icon,
                id: id,
                main: main,
                temperature: temp,
                maxTemperature: source[temperatureMaxKey] as? WeatherTemperature ?? invalidValueInt,
                minTemperature: source[temperatureMinKey] as? WeatherTemperature ?? invalidValueInt,
                windSpeed: source[windSpeedKey] as? WindSpeed ?? invalidValueDouble,
                location: location,
                updateDate: Date.init(timeIntervalSince1970: source[updateDateKey] as? TimeInterval ?? Date().timeIntervalSince1970))
        } else {
            return nil
        }
    }
}

typealias WeatherList = [Weather]
