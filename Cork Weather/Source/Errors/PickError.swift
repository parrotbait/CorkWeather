//
//  PickError.swift
//  Cork Weather
//
//  Created by Eddie Long on 10/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

enum PickError : Error {
    case backendError
    case notIreland
    case notCork
}
