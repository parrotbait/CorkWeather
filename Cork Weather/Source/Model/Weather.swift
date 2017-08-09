//
//  Weather.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

struct Weather {
    var description : String; // Weather condition within the group
    var icon : String; // Weather icon id
    var id : Int; // Weather condition id
    var main : String; // Group of weather parameters (Rain, Snow, Extreme etc.)
    var temperature : Int; // Celsius
    var maxTemperature : Int; // Celsius
    var minTemperature : Int; // Celsius
    var windSpeed : Double; // m/s
}
