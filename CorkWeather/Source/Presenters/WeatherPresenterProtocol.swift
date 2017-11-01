//
//  WeatherPresenterProtocol.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

protocol WeatherPresenter {
    typealias WeatherItemCallback = ((_ result : WeatherItemResult) -> Void)
    func fetch(_ location : WeatherLocation, callback : @escaping WeatherItemCallback)
    func getTime() -> String;
    func getUnitAsString(_ value : Int) -> String;
    
    // Weather data
    func removeWeatherAtIndex(index : Int)
    func numberOfWeatherItems() -> Int
    func getWeatherAtIndex(index : Int) -> Weather?
    func isLocationOk(_ coordinate : WeatherCoordinate) -> Bool
    func loadList()
    
    func showOnboarding(_ force : Bool) -> Bool
}
