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

    func showWeatherFetchFailure(reason: WeatherLoadError) {
        switch (reason) {
        case .backendError:
            
            DispatchQueue.main.async { [weak self] in
                let alertController = UIAlertController(title: Strings.get("Error_Title"), message: Strings.get("Backend_Error"), preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: Strings.get("Grand"), style: .default, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
            break;
        case .badUrl:
            DispatchQueue.main.async { [weak self] in
                let alertController = UIAlertController(title: Strings.get("Error_Title"), message: Strings.get("Backend_Error"), preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: Strings.get("Grand"), style: .default, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
            break
        case .missingKey:
            DispatchQueue.main.async { [weak self] in
                let alertController = UIAlertController(title: Strings.get("Error_Title"), message: Strings.get("Missing_Key_Error"), preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: Strings.get("Grand"), style: .default, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
            break
        case .parseError:
            DispatchQueue.main.async { [weak self] in
                let alertController = UIAlertController(title: Strings.get("Error_Title"), message: Strings.get("Bad_Json_Error"), preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: Strings.get("Grand"), style: .default, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
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
            DispatchQueue.main.async { [weak self] in
                let alert = UIAlertController(title: Strings.get("Error"), message: Strings.get("Not_Even_Ireland"), preferredStyle: .alert)  
                let action = UIAlertAction.init(title: Strings.get("Grand"), style: .default, handler: nil)
                alert.addAction(action)
                self?.present(alert, animated: true, completion: nil)
            }
            break
        case .notCork:
            DispatchQueue.main.async { [weak self] in
                let alert = UIAlertController(title: Strings.get("Error"), message: Strings.get("Not_Cork"), preferredStyle: .alert)
                let action = UIAlertAction.init(title: Strings.get("Grand"), style: .default, handler: nil)
                alert.addAction(action)
                self?.present(alert, animated: true, completion: nil)
            }
            break
        case .backendError:
            DispatchQueue.main.async { [weak self] in
                let alert = UIAlertController(title: Strings.get("Error"), message: Strings.get("Backend_Error"), preferredStyle: .alert)
                let action = UIAlertAction.init(title: Strings.get("Grand"), style: .default, handler: nil)
                alert.addAction(action)
                self?.present(alert, animated: true, completion: nil)
            }
            break
        case .alreadyPresent:
            DispatchQueue.main.async { [weak self] in
                let alert = UIAlertController(title: Strings.get("Error"), message: Strings.get("Already_Present"), preferredStyle: .alert)
                let action = UIAlertAction.init(title: Strings.get("Grand"), style: .default, handler: nil)
                alert.addAction(action)
                self?.present(alert, animated: true, completion: nil)
            }
            break;
        }
    }
}
