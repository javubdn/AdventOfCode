//
//  MainConfigurator.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 2/12/21.
//

import UIKit

class MainConfigurator {
    
    static func configure() -> UIViewController {
        let interactor = MainInteractorImpl()
        let presenter = MainPresenterImpl(interactor: interactor)
        let viewController = MainViewController(presenter: presenter, currentYear: .seventeen)
        return viewController
    }
    
}
