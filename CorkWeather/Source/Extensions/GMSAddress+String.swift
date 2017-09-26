//
//  GMSAddress+String.swift
//  Cork Weather
//
//  Created by Eddie Long on 10/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import GoogleMaps

extension GMSAddress {
    public func getText() -> String {
        return locality ?? subLocality ?? administrativeArea ?? "Cork"
    }
}
