//
//  MainViewController+GooglePlaces.swift
//  Cork Weather
//
//  Created by Eddie Long on 10/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import GooglePlaces
import GooglePlacePicker
import GoogleMaps
import SWLogger
import Proteus_Core

extension MainViewController : MapsProtocol, GMSPlacePickerViewControllerDelegate {
    
    func initialiseMapsApi() {
        GMSPlacesClient.provideAPIKey("AIzaSyBCS-5_abYlI5TqCti54rLM8qSym6Qh5js")
        GMSServices.provideAPIKey("AIzaSyBCS-5_abYlI5TqCti54rLM8qSym6Qh5js")
        geocoder = GMSGeocoder.init()
    }
    
    func showPicker() {
        analytics().logEvent(AnalyticsEvents.showPlacePicker)
        self.coordinator?.showPicker(delegate: self)
    }
    
    func readResponse(response : GMSReverseGeocodeResponse?, error : Error?) -> PickResult {
        if (error != nil || response == nil) {
            Log.e ("Error fetching reverse geocode \(error ?? "" as! Error)")
            return Result.failure(PickError.backendError)
        } else {
            //print ("address \(response?.firstResult())")
            if let address = response?.firstResult() {
                if address.country?.contains("Ireland") == false {
                    return .failure(PickError.notIreland)
                }
                else if (address.locality?.contains("Cork") == false && address.administrativeArea?.contains("Cork") == false) {
                    return .failure(PickError.notCork)
                }
                
                let coordinate = WeatherCoordinate.init(latitude: address.coordinate.latitude, longitude: address.coordinate.longitude)
                if (!presenter.isLocationOk(coordinate)) {
                    return .failure(PickError.alreadyPresent)
                }
                
                let weather = WeatherLocation.init(coordinate: coordinate, addressLines: address.lines, postcode: address.postalCode)
                
                return Result.success(weather)
            }
        }
        
        return Result.failure(PickError.backendError)
    }
    
    public func pickLocation(location : CLLocationCoordinate2D, callback : @escaping ((_ result : PickResult) -> Void)) {
        geocoder.reverseGeocodeCoordinate(location) { [weak self] response, error in
            callback(self!.readResponse(response: response, error: error))
        }
    }
    
    public func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        progressView.show(animated: true)
        analytics().logEvent(AnalyticsEvents.placePicked, [AnalyticsEvents.picked_longitude : place.coordinate.longitude, AnalyticsEvents.picked_latitude : place.coordinate.latitude])
        
        pickLocation(location: place.coordinate) { [weak self] result in
            self!.weatherLocationObtained(result: result)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    public func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
        Log.e ("Error with place picker \(error)")
        analytics().logEvent(AnalyticsEvents.placePickedError)
        progressView.hide(animated: true)
    }
}
