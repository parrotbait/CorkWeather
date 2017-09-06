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

extension MainViewController : MapsProtocol, GMSPlacePickerViewControllerDelegate {
    
    func initialiseMaps() {
        GMSPlacesClient.provideAPIKey("AIzaSyBCS-5_abYlI5TqCti54rLM8qSym6Qh5js")
        GMSServices.provideAPIKey("AIzaSyBCS-5_abYlI5TqCti54rLM8qSym6Qh5js")
        geocoder = GMSGeocoder.init()
    }
    
    func showPicker() {
        let zoomSize = 0.004
        let coordinates = ( 51.894981, -8.472618)
        let center = CLLocationCoordinate2D(latitude: coordinates.0, longitude: coordinates.1)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + zoomSize, longitude: center.longitude + zoomSize)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - zoomSize, longitude: center.longitude - zoomSize)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePickerViewController(config: config)
        
        // TODO: Move this elsewhere
        let searchBarTextAttributes: [String : AnyObject] = [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.systemFont(ofSize: UIFont.systemFontSize)]

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.classForCoder() as! UIAppearanceContainer.Type]).defaultTextAttributes = searchBarTextAttributes
        // Color of the placeholder text in the search bar prior to text entry.
        
        placePicker.delegate = self;
        self.navigationController?.pushViewController(placePicker, animated: true);
    }
    
    func readResponse(response : GMSReverseGeocodeResponse?, error : Error?) -> Result<WeatherLocation, PickError> {
        if (error != nil || response == nil) {
            print ("Error fetching reverse geocode \(error ?? "" as! Error)")
            return Result.failure(PickError.backendError)
        } else {
            //print ("address \(response?.firstResult())")
            if let address = response?.firstResult() {
                if address.country?.contains("Ireland") == false {
                    DispatchQueue.main.async { [weak self] in
                        let alert = UIAlertController(title: Strings.get("Error"), message: Strings.get("Not_Even_Ireland"), preferredStyle: .alert)
                        
                        let action = UIAlertAction.init(title: Strings.get("Grand"), style: .default, handler: nil)
                        alert.addAction(action)
                        self!.present(alert, animated: true, completion: nil)
                    }
                    return .failure(PickError.notIreland)
                }
                else if (address.locality?.contains("Cork") == false && address.administrativeArea?.contains("Cork") == false) {
                    DispatchQueue.main.async { [weak self] in
                        let alert = UIAlertController(title: Strings.get("Error"), message: Strings.get("Not_Cork"), preferredStyle: .alert)
                        let action = UIAlertAction.init(title: Strings.get("Grand"), style: .default, handler: nil)
                        alert.addAction(action)
                        self!.present(alert, animated: true, completion: nil)
                        //return Result.failure(PickError.notCork)
                    }
                    return .failure(PickError.notCork)
                }
                
                let coordinate = WeatherCoordinate.init(latitude: address.coordinate.latitude, longitude: address.coordinate.longitude)
                let weather = WeatherLocation.init(coordinate: coordinate, addressLines: address.lines, postcode: address.postalCode)
                
                return Result.success(weather)
            }
        }
        
        return Result.failure(PickError.backendError)
    }
    
    public func pickLocation(location : CLLocationCoordinate2D, callback : @escaping ((_ result : Result<WeatherLocation, PickError>) -> Void)) {
        geocoder.reverseGeocodeCoordinate(location) { [weak self] response, error in
            callback(self!.readResponse(response: response, error: error))
        }
    }
  
    
    public func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        print ("Place \(place)")
        // TODO: Remove this
        progressView.show(animated: true)
        
        pickLocation(location: place.coordinate) { [weak self] result in
            self!.weatherLocationObtained(result: result)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func saveLocation(address : GMSAddress, location: CLLocationCoordinate2D) {
        
    }
    
    public func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
        print ("Error with place picker \(error)")
    }
}
