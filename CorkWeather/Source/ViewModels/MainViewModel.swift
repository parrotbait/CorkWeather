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

protocol WeatherViewModel {
    typealias WeatherItemCallback = ((_ result : WeatherItemResult) -> Void)
    func fetch(_ location : WeatherLocation, callback : @escaping WeatherItemCallback)
    func getTime() -> String;
    
    // Weather data
    func removeWeatherAtIndex(index : Int)
    func numberOfWeatherItems() -> Int
    func getWeatherAtIndex(index : Int) -> Weather?
    
    typealias WeatherListCallback = ((_ result: DatabaseResult) -> Void)
    func loadWeatherList(callback: @escaping WeatherListCallback)
    
    func shouldShowOnboarding(_ force : Bool) -> Bool
}

class MainViewModel : WeatherViewModel {
    
    private var fetcher : WeatherFetcherProtocol
    public var desiredTemperature = TemperatureUnit.Celsius
    private let reverseGeocoder: ReverseGeocoderProvider
    private let dateFormatter = DateFormatter()
    private let database : Database
    private var weatherData = WeatherList()
    private var onboardingUserDefaults = "onboarding"
    
    init (fetcher : WeatherFetcherProtocol, database : Database, reverseGeocoder: ReverseGeocoderProvider) {
        self.fetcher = fetcher;
        self.database = database
        self.reverseGeocoder = reverseGeocoder
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = TimeZone.init(identifier: "Europe/Dublin")
        
        UserDefaults.standard.register(defaults: [onboardingUserDefaults: true])
    }
    
    func removeWeatherAtIndex(index: Int) {
        self.weatherData.remove(at: index)
        self.database.save(weatherList: self.weatherData)
    }
    
    func numberOfWeatherItems() -> Int {
        return self.weatherData.count
    }
    
    func getWeatherAtIndex(index: Int) -> Weather? {
        if (index < 0 || index >= self.weatherData.count) {
            return nil
        }
        return self.weatherData[index]
    }
    
    public func loadWeatherList(callback: @escaping WeatherListCallback) {
        self.database.load { [weak self]
            (result : DatabaseResult) in
            switch (result) {
            case .success(let weatherList):
                self?.weatherData = weatherList
                break
            default:
                break
            }
            
            callback(result)
        }
    }
    
    public func fetch(_ location : WeatherLocation, callback : @escaping WeatherItemCallback) {
        //fetcher.fetchType = WeatherFetcher.FetcherType.local(WeatherLocalFetcher())
        fetcher.fetch(location: location, unit: desiredTemperature) { [weak self] (result : WeatherItemResult) in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async { [weather] in
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
                    callback(Result.success(weather));
                    
                }
                break
            case .failure(let errorType):
                DispatchQueue.main.async {
                    callback(Result.failure(errorType))
                }
                break
            }
        }
    }
    
    public func getTime() -> String {
        return dateFormatter.string(from: Date())
    }
    
    public func shouldShowOnboarding(_ force : Bool = false) -> Bool {
        let shouldShow = UserDefaults.standard.bool(forKey: onboardingUserDefaults)
        if shouldShow {
            UserDefaults.standard.set(force, forKey: onboardingUserDefaults)
        }
        return shouldShow || force
    }
    
    public func reverseGeocode(location : CLLocationCoordinate2D, callback : @escaping ((_ result : PickResult) -> Void)) {
        self.reverseGeocoder.reverseGeocode(location: location) { (result) in
            switch (result) {
            case .success(let coordinate):
                // Make sure we're not adding a location that's already present
                if (!self.isLocationAlreadyPresent(coordinate.coordinate)) {
                    return callback(.failure(PickError.alreadyPresent))
                } else {
                    callback(result)
                }
                break
            case .failure(_):
                callback(result)
                break
            }
        }
    }
    
    private func isLocationAlreadyPresent(_ coordinate : WeatherCoordinate) -> Bool {
        for weather in self.weatherData {
            let distance = coordinate.distance(other: weather.location.coordinate)
            if distance <= 1.0 {
                Log.e("Coordinate \(coordinate) is too close to \(weather.location.coordinate) - distance \(distance)")
                return false
            }
        }
        
        return true
    }
    
}
