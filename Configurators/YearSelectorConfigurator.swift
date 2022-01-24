//
//  YearSelectorConfigurator.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 9/12/21.
//

import UIKit

class YearSelectorConfigurator {
    
    static func configure(_ window: UIWindow?) {
        let router = YearSelectorRouterImpl()
        let presenter = YearSelectorPresenterImpl(router: router)
        let viewController = YearSelectorViewController(presenter: presenter)
        let navigationController = UINavigationController(rootViewController: viewController)
        router.setNavigationController(navigationController)
        window?.rootViewController = navigationController
    }
    
}
