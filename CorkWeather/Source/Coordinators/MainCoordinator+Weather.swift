//
//  MainCoordinator+Weather.swift
//  CorkWeather
//
//  Created by Eddie Long on 10/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation
import GooglePlacePicker

extension MainCoordinator {
    func showInfo() {
        let viewcontroller = InfoViewController.instantiate()
        self.navigationController.pushViewController(viewcontroller, animated: true)
    }
    
    func showPicker(delegate: GMSPlacePickerViewControllerDelegate) {
        
        // TODO: Move these out to constants, remember last location
        let zoomSize = AppConfig.defaultZoomSize
        let coordinates = AppConfig.defaultPickerCoordinate
        
        let center = CLLocationCoordinate2D(latitude: coordinates.0, longitude: coordinates.1)
        let northEast = CLLocationCoordinate2D(latitude: center.latitude + zoomSize, longitude: center.longitude + zoomSize)
        let southWest = CLLocationCoordinate2D(latitude: center.latitude - zoomSize, longitude: center.longitude - zoomSize)
        let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
        let config = GMSPlacePickerConfig(viewport: viewport)
        let placePicker = GMSPlacePickerViewController(config: config)
        
        // Without setting the search bar color the GMS search field cannot be seen
        let searchBarTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)
        ]
        
        if let searchClass = UISearchBar.classForCoder() as? UIAppearanceContainer.Type {
            UITextField.appearance(whenContainedInInstancesOf: [searchClass]).defaultTextAttributes = searchBarTextAttributes
        }
        
        placePicker.delegate = delegate
        self.navigationController.pushViewController(placePicker, animated: true)
    }
    
    func hidePicker() {
        self.navigationController.popViewController(animated: true)
    }
}
