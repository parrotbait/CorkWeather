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
    func showPicker(coordinate: WeatherCoordinate, delegate: GMSPlacePickerViewControllerDelegate) {
        
        // TODO: Move these out to constants, remember last location
        let zoomSize = AppConfig.defaultZoomSize

        let config = GMSPlacePickerConfig.create(coordinate: coordinate, zoomSize: zoomSize)
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
