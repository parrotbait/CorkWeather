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
                } else if (address.locality?.contains("Cork") == false && address.administrativeArea?.contains("Cork") == false) {
                    return .failure(PickError.notCork)
                }
                
                let coordinate = WeatherCoordinate.init(latitude: address.coordinate.latitude, longitude: address.coordinate.longitude)
                let weather = WeatherLocation.init(coordinate: coordinate, addressLines: address.lines, postcode: address.postalCode)
                
                return Result.success(weather)
            }
        }
        
        return Result.failure(PickError.backendError)
    }
    
    public func reverseGeocode(location : CLLocationCoordinate2D, callback : @escaping ((_ result : PickResult) -> Void)) {
        geocoder.reverseGeocodeCoordinate(location) { response, error in
            callback(self.readResponse(response: response, error: error))
        }
    }
    
}
