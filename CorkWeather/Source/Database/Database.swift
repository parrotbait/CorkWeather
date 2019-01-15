//
//  Database.swift
//  Cork Weather
//
//  Created by Eddie Long on 24/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import Proteus_Core

typealias DatabaseResult = Result<WeatherList, DatabaseError>

protocol Database {
    func save(weatherList : WeatherList)
    typealias DatabaseCallback = ((DatabaseResult) -> Void)
    func load(callback : @escaping DatabaseCallback)
    
    // Get the last picked coordinate
    func lastCoordinatePicked() -> WeatherCoordinate
    func savePickedCoordinate(_ coord: WeatherCoordinate)
    
    func shouldShowOnboarding() -> Bool
}
