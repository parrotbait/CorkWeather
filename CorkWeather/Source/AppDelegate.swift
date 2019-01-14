//
//  AppDelegate.swift
//  Cork Weather
//
//  Created by Eddie Long on 03/08/2017.
//  Copyright © 2017 eddielong. All rights reserved.
//

import UIKit
import Firebase
import SWLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var coordinator: MainCoordinator?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
#if DEBUG
        //Log.setTagFilters(tags: ["MainVC"])
        Log.setLevel(.debug)
    
        if let docDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            print ("Documents directory: \(docDirectory)")
        }
#endif
        
        /*let logger = DefaultFileHandler()
        Log.addHandler(logger)
        */
        
        let navController = UINavigationController()
        // send that into our coordinator so that it can display view controllers
        coordinator = MainCoordinator(navController: navController)
        
        // tell the coordinator to take over control
        coordinator?.start()
        
        // create a basic UIWindow and activate it
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        
        // Override point for customization after application launch.
        return true
    }
}
