//
//  MainViewController+Alerts.swift
//  Cork Weather
//
//  Created by Eddie Long on 25/09/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import Foundation
import UIKit

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
            break;
        case .badUrl:
            showError(Strings.get("Backend_Error"))
            break
        case .missingKey:
            showError(Strings.get("Missing_Key_Error"))
            break
        case .parseError:
            showError(Strings.get("Bad_Json_Error"))
            break
        }
    }
    
    func showWeatherListLoadFailure(reason : DatabaseError) {
        switch (reason) {
        case .noData:
            DispatchQueue.main.async { [weak self] in
                let alertController = UIAlertController(title: Strings.get("Error_Title"), message: Strings.get("Backend_Error"), preferredStyle: .alert)
                
                alertController.addAction(UIAlertAction(title: Strings.get("Give_Up"), style: .cancel, handler: nil))
                alertController.addAction(UIAlertAction(title: Strings.get("Try_Again"), style: .default) { [weak self] action in
                    self?.presenter.loadList()
                })
                self?.present(alertController, animated: true, completion: nil)
            }
            break;
        }
    }
    
    func showWeatherPickError(reason : PickError) {
        switch (reason) {
        case .notIreland:
            showError(Strings.get("Not_Even_Ireland"))
            break
        case .notCork:
            showError(Strings.get("Not_Cork"))
            break
        case .backendError:
            showError(Strings.get("Backend_Error"))
            break
        case .alreadyPresent:
            showError(Strings.get("Already_Present"))
            break;
        }
    }
}
