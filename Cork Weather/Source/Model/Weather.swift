//
//  Weather.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

struct Weather {
    let description : String; // Weather condition within the group
    let icon : String; // Weather icon id
    let id : Int; // Weather condition id
    let main : String; // Group of weather parameters (Rain, Snow, Extreme etc.)
    let temperature : Int; // Celsius
    let maxTemperature : Int; // Celsius
    let minTemperature : Int; // Celsius
    let windSpeed : Double; // m/s
    let location : WeatherLocation;
}
