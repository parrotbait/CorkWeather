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
        let vc = MainViewController.instantiate()
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
}
