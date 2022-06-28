//
//  DetailConfigurator.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 23/6/22.
//

import UIKit

class DetailConfigurator {
    
    static func configure(_ year: Year, _ day: Int) -> UIViewController {
        let viewController = DetailViewController(year, day)
        return viewController
    }
    
}
