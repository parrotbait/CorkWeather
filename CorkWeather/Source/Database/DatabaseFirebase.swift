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
    var ref: DatabaseReference!
    
    let weatherKey = "weather"
    
    init() {
        ref = FirebaseDatabase.Database.database().reference()
    }
    
    func save(weatherList: WeatherList) {
        self.ref.child(weatherKey).removeValue()
        for weather in weatherList {
            
            let newChild = self.ref.child(weatherKey).childByAutoId()
            newChild.setValue(weather.toArray())
        }
    }
    
    func load(callback : @escaping DatabaseCallback) {
        Auth.auth().signInAnonymously { [weak self] (user, error) in
            if let er = error {
                Log.d(er.localizedDescription)
            } else {
                self?.ref.child((self?.weatherKey)!).observeSingleEvent(of: DataEventType.value) { (snapshot : DataSnapshot) in
                    var weatherList = WeatherList()
                    if !snapshot.exists() {
                        callback(Result.success(weatherList))
                        return
                    }
                    
                    for child in snapshot.children.allObjects as? [DataSnapshot] ?? [] {
                        if let childArr = child.value as? [String: Any] {
                            weatherList.append(Weather.fromArray(source: childArr))
                        }
                    }
                    callback(Result.success(weatherList))
                }
            }
        }
        
    }
}
