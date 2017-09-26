//
//  LogLine.swift
//  Cork Weather
//
//  Created by Eddie Long on 07/09/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

public struct LogLine {
    let message : String
    let filename : String
    let funcName : String
    let line : Int
    let column : Int
    let extra : Any
}
