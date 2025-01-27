//
//  AppDelegate.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 2/12/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController()
        let yearSelectorViewController = YearSelectorConfigurator.configure(navigationController: navigationController)
        navigationController.viewControllers = [yearSelectorViewController]
        window?.rootViewController = navigationController
        return true
    }

}

