//
//  MainViewController.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 2/12/21.
//

import UIKit
import CoreXLSX

class MainViewController: UIViewController {
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var yearLabel: UILabel!
    
    let presenter: MainPresenter
    let currentYear: Year
    var dayViews: [DayView] = []
    
    init(presenter: MainPresenter, currentYear: Year) {
        self.presenter = presenter
        self.currentYear = currentYear
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViews()
        calculations()
    }
    
    private func prepareViews() {
        yearLabel.text = String(currentYear.value())
        let numberDaysPerYear = [Year.fifteen: 25,
                                 Year.sixteen: 25,
                                 Year.seventeen: 25,
                                 Year.eighteen: 25,
                                 Year.nineteen: 25,
                                 Year.twenty: 25,
                                 Year.twentyOne: 25,
                                 Year.twentyTwo: 25,
                                 Year.twentyThree: 13]
        for index in 0..<numberDaysPerYear[currentYear]! {
            let dayView = DayView(currentYear, index, mainStackView, self)
            dayViews.append(dayView)
        }
    }

    private func calculations() {
        let queue = DispatchQueue(label: "com.AdventOfCode.queue")
        for index in 0..<dayViews.count {
            queue.async {
                let answer1 = self.presenter.calculate(year: self.currentYear, day: index+1, question: 1)
                let answer2 = self.presenter.calculate(year: self.currentYear, day: index+1, question: 2)
                DispatchQueue.main.async {
                    self.dayViews[index].setAnswers((answer1, answer2))
                }
            }
        }
    }
    
}

extension MainViewController: DayViewDelegate {
    
    func openDetail(_ year: Year, _ day: Int) {
        presenter.openDetail(year, day)
    }
    
}
