//
//  MainRouterImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 23/6/22.
//

import UIKit

class MainRouterImpl: MainRouter {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func openDetail(_ year: Year, _ day: Int) {
        let detailViewController = DetailConfigurator.configure(year, day)
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
}
