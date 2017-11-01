//
//  AnalyticsProtocol.swift
//  CorkWeather
//
//  Created by Eddie Long on 01/11/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

protocol AnalyticsProtocol {
    func logEvent(_ event : String)
    func logEvent(_ event : String, _ parameters : [String : Any])
}
