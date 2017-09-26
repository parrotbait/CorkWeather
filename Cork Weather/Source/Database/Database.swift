//
//  Database.swift
//  Cork Weather
//
//  Created by Eddie Long on 24/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation

typealias DatabaseResult = Result<[Weather], DatabaseError>

protocol Database {
    func save(weatherList : [Weather])
    typealias DatabaseCallback = ((DatabaseResult) -> Void)
    func load(callback : @escaping DatabaseCallback)
}
