//
//  Database.swift
//  Cork Weather
//
//  Created by Eddie Long on 24/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

protocol Database {
    func save(weatherList : [Weather])
    typealias DatabaseCallback = ((_ : Bool, _ : [Weather]) -> Void)
    func load(callback : @escaping DatabaseCallback)
}
