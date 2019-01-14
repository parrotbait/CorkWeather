//
//  DatabaseFirebase.swift
//  Cork Weather
//
//  Created by Eddie Long on 31/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import SWLogger
import CoreLocation
import Proteus_Core

class DatabaseFirebase : Database {
    var databaseRef: DatabaseReference!
    
    let weatherKey = "weather"
    
    init() {
        databaseRef = FirebaseDatabase.Database.database().reference()
    }
    
    func save(weatherList: WeatherList) {
        self.databaseRef.child(weatherKey).removeValue()
        for weather in weatherList {
            
            let newChild = self.databaseRef.child(weatherKey).childByAutoId()
            newChild.setValue(weather.toArray())
        }
    }
    
    func load(callback : @escaping DatabaseCallback) {
        Auth.auth().signInAnonymously { [weak self] (_, error) in
            if let dbError = error {
                Log.d(dbError.localizedDescription)
            } else {
                self?.databaseRef.child((self?.weatherKey)!).observeSingleEvent(of: DataEventType.value) { (snapshot : DataSnapshot) in
                    var weatherList = WeatherList()
                    if !snapshot.exists() {
                        callback(Result.success(weatherList))
                        return
                    }
                    
                    for child in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
                        if let childArr = child.value as? [String: Any] {
                            if let weather = Weather.fromArray(source: childArr) {
                                weatherList.append(weather)                                
                            }
                        }
                    }
                    callback(Result.success(weatherList))
                }
            }
        }
        
    }
}
