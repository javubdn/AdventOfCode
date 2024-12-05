//
//  YearSelectorConfigurator.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 9/12/21.
//

import UIKit

class YearSelectorConfigurator {
    
    static func configure(navigationController: UINavigationController) -> UIViewController {
        let router = YearSelectorRouterImpl()
        let presenter = YearSelectorPresenterImpl(router: router)
        let viewController = YearSelectorViewController(presenter: presenter)
        router.setNavigationController(navigationController)
        return viewController
    }
    
}
