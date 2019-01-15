//
//  MainViewController+Alerts.swift
//  Cork Weather
//
//  Created by Eddie Long on 25/09/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import UIKit
import Proteus_Core

extension MainViewController : MainAlertProtocol {

    func showError(_ errorText : String) {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: Strings.get("Error_Title"), message: errorText, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: Strings.get("Grand"), style: .default, handler: nil))
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showWeatherFetchFailure(reason: WeatherLoadError) {
        switch (reason) {
        case .backendError:
            showError(Strings.get("Backend_Error"))
        case .badUrl:
            showError(Strings.get("Backend_Error"))
        case .missingKey:
            showError(Strings.get("Missing_Key_Error"))
        case .parseError:
            showError(Strings.get("Bad_Json_Error"))
        }
    }
    
    func showWeatherListLoadFailure(reason : DatabaseError, retryCallback: @escaping RetryCallback) {
        
        switch (reason) {
        case .noData:
            DispatchQueue.main.async { [weak self] in
                let alertController = UIAlertController(title: Strings.get("Error_Title"), message: Strings.get("Backend_Error"), preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: Strings.get("Give_Up"), style: .cancel, handler: nil))
                alertController.addAction(UIAlertAction(title: Strings.get("Try_Again"), style: .default) { _ in
                    retryCallback()
                })
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func showWeatherPickError(reason : PickError) {
        switch (reason) {
        case .notIreland:
            showError(Strings.get("Not_Even_Ireland"))
        case .notCork:
            showError(Strings.get("Not_Cork"))
        case .jackeen:
            showError(Strings.get("Dublin"))
        case .backendError:
            showError(Strings.get("Backend_Error"))
        case .alreadyPresent:
            showError(Strings.get("Already_Present"))
        }
    }
}
