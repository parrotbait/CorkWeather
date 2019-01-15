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
    private let databaseRef: DatabaseReference
    private let weatherKey = "weather"
    private let latKey = "coord_lat"
    private let lonKey = "coord_lon"
    private var onboardingUserDefaults = "onboarding"
    
    init() {
        databaseRef = FirebaseDatabase.Database.database().reference()
        UserDefaults.standard.register(defaults: [onboardingUserDefaults: true])
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
    
    func lastCoordinatePicked() -> WeatherCoordinate {
        if UserDefaults.standard.contains(latKey) {
            return AppConfig.defaultPickerCoordinate
        }
        let lat = UserDefaults.standard.double(forKey: latKey)
        let lon = UserDefaults.standard.double(forKey: lonKey)
        return WeatherCoordinate.init(latitude: lat, longitude: lon)
        
    }
    
    func savePickedCoordinate(_ coord: WeatherCoordinate) {
        UserDefaults.standard.set(coord.latitude, forKey: latKey)
        UserDefaults.standard.set(coord.longitude, forKey: lonKey)
    }
    
    func shouldShowOnboarding() -> Bool {
        if UserDefaults.standard.contains(onboardingUserDefaults) {
            return UserDefaults.standard.bool(forKey: onboardingUserDefaults)
        }
        
        // Default is to show onboarding
        UserDefaults.standard.set(true, forKey: onboardingUserDefaults)
        return true
    }
}
