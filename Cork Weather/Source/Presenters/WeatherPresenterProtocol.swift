//
//  WeatherPresenterProtocol.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

protocol WeatherPresenter {
    func fetch(_ location : String)
    func getTime() -> String;
    func getUnitAsString(_ value : Int) -> String;
}
