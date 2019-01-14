//
//  AnalyticsFactory.swift
//  CorkWeather
//
//  Created by Eddie Long on 01/11/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

struct AnalyticsFactory {
    public static func get() -> AnalyticsProtocol {
        return AnalyticsFirebase()
    }
}

private let analyticsObj = AnalyticsFactory.get()

func analytics() -> AnalyticsProtocol {
    return analyticsObj
}
