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
    
    func showPicker() {
        analytics().logEvent(AnalyticsEvents.showPlacePicker)
        self.coordinator?.showPicker(delegate: self)
    }

    public func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        progressView.show(animated: true)
        analytics().logEvent(AnalyticsEvents.placePicked, [AnalyticsEvents.picked_longitude : place.coordinate.longitude, AnalyticsEvents.picked_latitude : place.coordinate.latitude])
        
        self.viewModel!.reverseGeocode(location: place.coordinate) { (result) in
            self.weatherLocationObtained(result: result)
        }
        
        self.coordinator?.hidePicker();
    }
    
    public func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
        Log.e ("Error with place picker \(error)")
        analytics().logEvent(AnalyticsEvents.placePickedError)
        progressView.hide(animated: true)
    }
}
