//
//  WeatherViewProtocol.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

protocol WeatherViewProtocol {
    func weatherLoaded(weather : Weather);
    func weatherLoadFailed();
}
