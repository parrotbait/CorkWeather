//
//  MainViewModel.swift
//  CorkWeather
//
//  Created by Eddie Long on 11/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation
import SWLogger
import Proteus_Core
import CoreLocation

typealias WeatherItemResult = Result<Weather, WeatherLoadError>
typealias WeatherItemCallback = ((_ result : WeatherItemResult) -> Void)
typealias WeatherListCallback = ((_ result: DatabaseResult) -> Void)

// TODO: This class does too many things: database access, reverse geocoding, weather API fetching, picker coordinates
class MainViewModel {
    
    private var api : APIClient
    public var desiredTemperature = TemperatureUnit.celsius
    
    private let reverseGeocoder: ReverseGeocoderProvider
    private let database : Database
    private var weatherData = WeatherList()
    
    init (api : APIClient, database : Database, reverseGeocoder: ReverseGeocoderProvider) {
        self.api = api
        self.database = database
        self.reverseGeocoder = reverseGeocoder
    }
    
    func removeWeatherAtIndex(index: Int) {
        if index >= self.weatherData.count {
            fatalError("Invalid index \(index)")
        }
        
        self.weatherData.remove(at: index)
        self.database.save(weatherList: self.weatherData)
    }
    
    func numberOfWeatherItems() -> Int {
        return self.weatherData.count
    }
    
    func getWeatherViewModelAtIndex(index: Int) -> WeatherCellViewModel? {
        if (index < 0 || index >= self.weatherData.count) {
            return nil
        }
        
        return WeatherCellViewModel.init(desiredTemperature, weather: self.weatherData[index])
    }
    
    public func loadWeatherList(callback: @escaping WeatherListCallback) {
        self.database.load { [weak self] (result : DatabaseResult) in
            switch (result) {
            case .success(let weatherList):
                self?.weatherData = weatherList
            default:
                // Do nothing
                break
            }
            
            callback(result)
        }
    }
    
    public func fetch(_ location : WeatherLocation, callback : @escaping WeatherItemCallback) {
        let request = WeatherRequest.forLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, unit: desiredTemperature)
        api.perform(request: request) { [weak self] (result) in
            switch result {
            case .success(let response):
                if var weather: Weather = response.toJson() {
                    weather.updateDate = Date()
                    weather.location = location
                    let result = self?.weatherData.contains(weather)
                    if result == false {
                        self?.weatherData.append(weather)
                    } else {
                        if let index = self?.weatherData.index(of: weather) {
                            self?.weatherData[index] = weather
                        }
                    }
                    // Persist
                    if let weatherData = self?.weatherData {
                        self?.database.save(weatherList: weatherData)
                        
                    }
                    DispatchQueue.main.async {
                        callback(Result.success(weather))
                    }
                }
            case .failure:
                DispatchQueue.main.async {
                    callback(Result.failure(WeatherLoadError.backendError))
                }
            }
        }
    }
    
    public func shouldShowOnboarding(_ force : Bool = false) -> Bool {
        return self.database.shouldShowOnboarding() || force
    }
    
    public func reverseGeocode(location : WeatherCoordinate, callback : @escaping ((_ result : PickResult) -> Void)) {
        self.reverseGeocoder.reverseGeocode(location: location) { (result) in
            switch (result) {
            case .success(let coordinate):
                // Make sure we're not adding a location that's already present
                if (!self.isLocationAlreadyPresent(coordinate.coordinate)) {
                    return callback(.failure(PickError.alreadyPresent))
                } else {
                    callback(result)
                }
            case .failure:
                callback(result)
            }
        }
    }
    
    private func isLocationAlreadyPresent(_ coordinate : WeatherCoordinate) -> Bool {
        for weather in self.weatherData {
            let distance = coordinate.distance(other: weather.coordinate)
            if distance <= 1.0 {
                Log.e("Coordinate \(coordinate) is too close to \(weather.location) - distance \(distance)")
                return false
            }
        }
        
        return true
    }
    
    public func getLastPickerCoord() -> WeatherCoordinate {
        return self.database.lastCoordinatePicked()
    }
    
    public func savePickedCoordinate(_ coord: WeatherCoordinate) {
        self.database.savePickedCoordinate(coord)
    }
}
