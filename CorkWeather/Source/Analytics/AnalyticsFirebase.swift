//
//  AnalyticsFirebase.swift
//  CorkWeather
//
//  Created by Eddie Long on 01/11/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import FirebaseAnalytics

struct AnalyticsFirebase : AnalyticsProtocol {
    public func logEvent(_ event: String) {
        Analytics.logEvent(event, parameters: nil)
    }
    
    public func logEvent(_ event: String, _ parameters: [String : Any]) {
        Analytics.logEvent(event, parameters: parameters)
    }
}
