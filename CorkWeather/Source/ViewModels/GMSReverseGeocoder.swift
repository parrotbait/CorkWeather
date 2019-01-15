//
//  MainViewModel+Maps.swift
//  CorkWeather
//
//  Created by Eddie Long on 11/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import SWLogger
import Proteus_Core

struct GMSReverseGeocoder: ReverseGeocoderProvider {
    let geocoder: GMSGeocoder!
    
    init() {
        GMSPlacesClient.provideAPIKey(sharedConfig.googleAPIKey)
        GMSServices.provideAPIKey(sharedConfig.googleAPIKey)
        geocoder = GMSGeocoder.init()
    }
    
    func handleNonCorkLocation(_ location: String) -> PickResult {
        switch (location) {
        case "Dublin":
            return .failure(PickError.jackeen)
        default:
            return .failure(PickError.notCork)
        }
    }
    
    func readResponse(response : GMSReverseGeocodeResponse?, error : Error?) -> PickResult {
        if (error != nil || response == nil) {
            if let err = error {
                Log.e ("Error fetching reverse geocode \(err)")
            } else {
                Log.e("Missing geocode response body")
            }
            return Result.failure(PickError.backendError)
        } else {
            //print ("address \(response?.firstResult())")
            if let address = response?.firstResult() {
                if address.country?.contains("Ireland") == false {
                    return .failure(PickError.notIreland)
                } else {
                    if let locality = address.locality {
                        if !locality.contains("Cork") {
                            return handleNonCorkLocation(locality)
                        }
                    }
                    if let admin = address.administrativeArea {
                        if !admin.contains("Cork") {
                            return handleNonCorkLocation(admin)
                        }
                    }
                }
                
                let coordinate = WeatherCoordinate.init(latitude: address.coordinate.latitude, longitude: address.coordinate.longitude)
                let weather = WeatherLocation.init(coordinate: coordinate, addressLines: address.lines, postcode: address.postalCode)
                
                return Result.success(weather)
            }
        }
        
        return Result.failure(PickError.backendError)
    }
    
    public func reverseGeocode(location : WeatherCoordinate, callback : @escaping ((_ result : PickResult) -> Void)) {
        let clCoord = CLLocationCoordinate2D.init(latitude: location.latitude, longitude: location.longitude)
        geocoder.reverseGeocodeCoordinate(clCoord) { response, error in
            callback(self.readResponse(response: response, error: error))
        }
    }
}
