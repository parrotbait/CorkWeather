//
//  DatabaseFirebase.swift
//  Cork Weather
//
//  Created by Eddie Long on 31/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import FirebaseDatabase
import CoreLocation

class DatabaseFirebase : Database {
    var ref: DatabaseReference!
    
    let weatherKey = "weather"
    
    init() {
        ref = FirebaseDatabase.Database.database().reference()
    }
    
    func save(weatherList: [Weather]) {
        for weather in weatherList {
            let newChild = self.ref.child(weatherKey).child("\(weather.id)");
            newChild.setValue(weather.toArray())
        }
    }
    
    func load(callback : @escaping DatabaseCallback) {
        ref.child(weatherKey).observeSingleEvent(of: DataEventType.value) { (snapshot : DataSnapshot) in
            var weatherList = [Weather]()
            if !snapshot.exists() {
                callback(false, weatherList)
                return
            }
            
            for child in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
                if let childArr = child.value as? [String: Any] {
                    weatherList.append(Weather.fromArray(source: childArr))
                }
            }
            callback(true, weatherList)
        }
    }
}
