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
import CodableFirebase

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
            do {
                if let data = try? FirebaseEncoder().encode(weather) {
                    newChild.setValue(data)
                }
            } catch {
                print(error)
            }
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
                        guard let value = child.value else { return }
                        do {
                            let weather = try FirebaseDecoder().decode(Weather.self, from: value)
                            weatherList.append(weather)
                        } catch {
                            callback(.failure(DatabaseError.internalError(error: error)))
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
