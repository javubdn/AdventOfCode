//
//  DetailViewController.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 23/6/22.
//

import UIKit

class DetailViewController: UIViewController {

    private let year: Year
    private let day: Int
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    init(_ year: Year, _ day: Int) {
        self.year = year
        self.day = day
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if day == 24 && year == .nineteen {
            let detailView = Detail2019_25View(mainStackView)
            detailView.initializeComputer()
        }
    }

}
