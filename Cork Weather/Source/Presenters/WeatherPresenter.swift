//
//  WeatherPresenter.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

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
    
    public func load() {
        
        self.database.load { [weak self]
            (result : Bool, resultWeather : [Weather]) in
            if (result) {
                self?.weatherData = resultWeather
                
                if let presenter = self {
                    presenter.view?.loaded(result: Result.success(resultWeather))
                }
                /*
                self?.fetcher.fetchMultiple(weather: resultWeather, unit: self!.desiredTemperature, completion: { [weak self]
                    (multipleFetchResult : Bool) in
                    
                })*/
            } else {
                
            }
            
            /*DispatchQueue.main.async {
                [weak self] in
                self?.weatherData = resultWeather
                self?.weatherList.reloadData()
            }*/
        }
    }
    
    public func fetch(_ location : WeatherLocation) {
        //fetcher.fetchType = WeatherFetcher.FetcherType.local(WeatherLocalFetcher())
        fetcher.fetch(location: location, unit: desiredTemperature) { [weak self] (result : Bool, weather : Weather?) in
            var isOk = false;
            if result && weather != nil {
                DispatchQueue.main.async { [weather] in
                    if let weatherIn : Weather = weather {
                        self?.weatherData.append(weatherIn)
                        // Persist
                        if let weatherData = self?.weatherData {
                            self?.database.save(weatherList: weatherData)
                            self?.view!.weatherLoaded(result: Result.success(weatherIn));
                        }
                    }
                }
                isOk = true
            }
            
            if !isOk {
                DispatchQueue.main.async {
                    self?.view!.weatherLoaded(result: Result.failure(WeatherLoadError.backendError))
                }
            }
        }
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
