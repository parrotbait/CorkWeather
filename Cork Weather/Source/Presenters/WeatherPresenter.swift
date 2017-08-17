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
    
    init (view : WeatherViewProtocol, fetcher : WeatherFetcherProtocol) {
        self.view = view;
        self.fetcher = fetcher;
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = TimeZone.init(identifier: "Europe/Dublin")
    }
    public func fetch(_ location : WeatherLocation) {
        //fetcher.fetchType = WeatherFetcher.FetcherType.local(WeatherLocalFetcher())
        fetcher.fetch(location: location, unit: desiredTemperature) { [weak self] (result : Bool, weather : Weather?) in
            var isOk = false;
            if result && weather != nil {
                DispatchQueue.main.async { [weather] in
                    if let weatherIn : Weather = weather {
                        self?.view!.weatherLoaded(weather: weatherIn);
                    }
                }
                isOk = true
            }
            
            if !isOk {
                DispatchQueue.main.async {
                    self?.view!.weatherLoadFailed();
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
