//
//  YearSelectorRouterImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 9/12/21.
//

import Foundation
import UIKit

class YearSelectorRouterImpl: YearSelectorRouter {
    
    private var navigationController: UINavigationController!
    
    init() {
    }
    
    func setNavigationController(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigateTo(year: Int) {
        let mainViewController = MainConfigurator.configure(navigationController: navigationController)
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
}
