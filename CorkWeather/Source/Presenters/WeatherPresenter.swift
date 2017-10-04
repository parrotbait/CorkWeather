//
//  WeatherPresenter.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import SWLogger

class WeatherPresenterImpl : WeatherPresenter {
    
    var fetcher : WeatherFetcherProtocol;
    weak var view : WeatherViewProtocol?;
    var desiredTemperature = TemperatureUnit.Celsius
    let dateFormatter = DateFormatter()
    let database : Database
    var weatherData = [Weather]()
    
    init (view : WeatherViewProtocol, fetcher : WeatherFetcherProtocol, database : Database) {
        self.view = view;
        self.fetcher = fetcher;
        self.database = database
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = TimeZone.init(identifier: "Europe/Dublin")
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
    
    public func loadList() {
        
        self.database.load { [weak self]
            (result : DatabaseResult) in
            switch (result) {
            case .success(let weatherList):
                self?.weatherData = weatherList
                break
            default:
                break
            }
            
            if let presenter = self {
                presenter.view?.databaseLoaded(result: result)
            }
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
    
    private func getDistanceBetweenPoints(location1 : WeatherCoordinate, location2 : WeatherCoordinate) -> Double {
        let R = 6371.0; // Radius of the earth in km
        let diffLatitude = (location2.latitude - location1.latitude).degreesToRadians;
        let diffLongitude = (location2.longitude - location1.longitude).degreesToRadians;
        let a =
            sin(diffLatitude / 2) * sin(diffLatitude / 2) +
                cos(location1.latitude.degreesToRadians) * cos(location2.latitude.degreesToRadians) *
                sin(diffLongitude / 2) * sin(diffLongitude / 2)
        let c = 2.0 * atan2(sqrt(a), sqrt(1 - a))
        let distance = R * c;
        return distance
    }
    
    public func isLocationOk(_ coordinate : WeatherCoordinate) -> Bool {
        for weather in self.weatherData {
            let distance = getDistanceBetweenPoints(location1: coordinate, location2: weather.location.coordinate)
            if distance <= 1.0 {
                Log.e("Coordinate \(coordinate) is too close to \(weather.location.coordinate) - distance \(distance)")
                return false
            }
        }
        
        return true
    }
    
    public func getUnitAsString(_ value : Int) -> String {
        switch (desiredTemperature) {
        case .Celsius:
            return String(format: "%d °C", value);
        case .Fahrenheit:
            return String(format: "%d °F", value);
        case .Kelvin:
            return String(format: "%d °K", value);
        }
    }
    
    public func getTime() -> String {
        return dateFormatter.string(from: Date())
    }
}
