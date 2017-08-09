//
//  WeatherPresenter.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

class WeatherPresenterImpl : WeatherPresenter {
    
    var fetcher : WeatherFetcherProtocol!;
    var view : WeatherViewProtocol? = nil;
    var desiredTemperature = TemperatureUnit.Celsius
    let dateFormatter = DateFormatter()
    
    init (view : WeatherViewProtocol, fetcher : WeatherFetcherProtocol) {
        self.view = view;
        self.fetcher = fetcher;
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .medium
        dateFormatter.timeZone = TimeZone.init(identifier: "Europe/Dublin")
    }
    public func fetch(_ location : String) {
        //fetcher.fetchType = WeatherFetcher.FetcherType.local(WeatherLocalFetcher())
        fetcher.fetch(location: location, unit: desiredTemperature) { [weak self] (result : Bool, weather : Weather?) in
            DispatchQueue.main.async {
                if (result) {
                    self?.view?.weatherLoaded(weather: weather!);
                } else {
                    self?.view?.weatherLoadFailed();
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
