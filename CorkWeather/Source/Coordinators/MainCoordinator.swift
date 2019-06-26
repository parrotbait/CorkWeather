//
//  MainCoordinator.swift
//  CorkWeather
//
//  Created by Eddie Long on 10/01/2019.
//  Copyright © 2019 eddielong. All rights reserved.
//

import Foundation
import Proteus_UI

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init (navController: UINavigationController) {
        self.navigationController = navController
    }
    
    func start() {
        let viewcontroller = MainViewController.instantiate()
        viewcontroller.coordinator = self
        let api = APIClient(environment: currentEnvironment, config: sharedConfig)
        viewcontroller.viewModel = MainViewModel(api: api,
                                     database: DatabaseFirebase(), reverseGeocoder: GMSReverseGeocoder())
        
        self.navigationController.pushViewController(viewcontroller, animated: true)
    }
    
    func showInfo() {
        let viewcontroller = InfoViewController.instantiate()
        self.navigationController.pushViewController(viewcontroller, animated: true)
    }
}
