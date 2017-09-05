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
    var location : WeatherLocation;
    
    static let idKey = "id"
    static let descriptionKey = "description"
    static let iconKey = "icon"
    static let mainKey = "main"
    static let temperatureKey = "temperature"
    static let temperatureMinKey = "min_temperature"
    static let temperatureMaxKey = "max_temperature"
    static let windSpeedKey = "wind_speed"
    static let postcodeKey = "postcode"
    static let latitudeKey = "latitude"
    static let longitudeKey = "longitude"
    static let addressLinesKey = "address_lines"
    static let invalidValueInt = -1
    static let invalidValueDouble = -1.0
    
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
        Weather.addressLinesKey : location.addressLines ?? ""
        ];
    }
    
    public static func fromArray(source : [String: Any]) -> Weather {
        let coords = WeatherCoordinate(latitude: source[latitudeKey] as! Double, longitude: source[longitudeKey] as! Double);
        let location = WeatherLocation.init(coordinate: coords, addressLines: source[addressLinesKey] as? [String], postcode: source[postcodeKey] as? String)
        return Weather.init(
                description: source[descriptionKey] as! String,
                icon: source[iconKey] as! String,
                id: source[idKey] as! WeatherID,
                main: source[mainKey] as! String,
                temperature: source[temperatureKey] as! WeatherTemperature,
                maxTemperature: source[temperatureMaxKey] as? WeatherTemperature ?? invalidValueInt,
                minTemperature: source[temperatureMinKey] as? WeatherTemperature ?? invalidValueInt,
                windSpeed: source[windSpeedKey] as? WindSpeed ?? invalidValueDouble,
                location: location)
    }
}
