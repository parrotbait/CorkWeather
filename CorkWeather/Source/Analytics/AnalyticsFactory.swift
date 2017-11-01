//
//  AnalyticsFactory.swift
//  CorkWeather
//
//  Created by Eddie Long on 01/11/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

struct AnalyticsFactory {
    static var analytics = AnalyticsFirebase()
    
    public static func get() -> AnalyticsProtocol {
        return analytics
    }
}

func analytics() -> AnalyticsProtocol {
    return AnalyticsFactory.get()
}
