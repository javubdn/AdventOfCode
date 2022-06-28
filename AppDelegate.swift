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
        window?.rootViewController =  MainConfigurator.configure(navigationController: UINavigationController())
//        YearSelectorConfigurator.configure(window)
        return true
    }

}

