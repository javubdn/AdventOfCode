//
//  YearSelectorViewController.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 9/12/21.
//

import UIKit

class YearSelectorViewController: UIViewController {

    let presenter: YearSelectorPresenter
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.navigateTo(year: .twentyTwo)

    }

    
    
}
