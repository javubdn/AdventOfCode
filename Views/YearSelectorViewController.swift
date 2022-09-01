//
//  YearSelectorViewController.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 9/12/21.
//

import UIKit

class YearSelectorViewController: UIViewController {

    let presenter: YearSelectorPresenter
    
    init(presenter: YearSelectorPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.navigateTo(year: .twentyOne)

    }

    //MARK: - Actions
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        presenter.navigateTo(year: .twentyOne)
    }
    
}
