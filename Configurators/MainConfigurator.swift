//
//  MainConfigurator.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 2/12/21.
//

import UIKit

class MainConfigurator {
    
    static func configure(navigationController: UINavigationController, year: Year) -> UIViewController {
        let interactor = MainInteractorImpl()
        let router = MainRouterImpl(navigationController: navigationController)
        let presenter = MainPresenterImpl(interactor: interactor, router: router)
        let viewController = MainViewController(presenter: presenter, currentYear: year)
        return viewController
    }
    
}
