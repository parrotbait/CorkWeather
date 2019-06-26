//
//  Config.swift
//  CorkWeather
//
//  Created by Eddie Long on 26/06/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation

enum EnvironmentType {
    case dev
    case staging
    case production
}

struct Environment {
    let baseUrl: String
}

let environments: [EnvironmentType: Environment] = [
    .dev: Environment(baseUrl: "https://api.openweathermap.org/data/2.5/"),
    .staging: Environment(baseUrl: "https://api.openweathermap.org/data/2.5/"),
    .production: Environment(baseUrl: "https://api.openweathermap.org/data/2.5/")
]
