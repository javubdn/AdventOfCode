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
    var answerViews: [[UILabel]] = []
    
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
        let numberDaysPerYear = [Year.fifteen: 25, Year.sixteen: 16, Year.twenty: 0, Year.twentyOne: 17]
        for index in 0..<numberDaysPerYear[currentYear]! {
            let dayView = UIView()
            dayView.layer.borderWidth = 2
            dayView.layer.borderColor = .init(red: 0, green: 0.2, blue: 0.7, alpha: 1)
            dayView.layer.cornerRadius = 5

            let titleDayLabel = UILabel()
            titleDayLabel.text = "Día \(index + 1)"
            titleDayLabel.textAlignment = .center
            titleDayLabel.font = UIFont(name: "Futura-Medium", size: 20.0)

            let question1Label = UILabel()
            question1Label.text = "Primera parte"
            question1Label.textAlignment = .left
            
            let answer1Label = UILabel()
            answer1Label.text = "Calculando..."
            answer1Label.textAlignment = .right
            
            let q1StackView = UIStackView(arrangedSubviews: [question1Label, answer1Label])
            q1StackView.axis = .horizontal
            q1StackView.spacing = 15

            let question2Label = UILabel()
            question2Label.text = "Segunda parte"
            question2Label.textAlignment = .left

            let answer2Label = UILabel()
            answer2Label.text = "Calculando..."
            answer2Label.textAlignment = .right

            let q2StackView = UIStackView(arrangedSubviews: [question2Label, answer2Label])
            q2StackView.axis = .horizontal
            q2StackView.spacing = 15

            let vStackView = UIStackView(arrangedSubviews: [titleDayLabel, q1StackView, q2StackView])
            vStackView.axis = .vertical
            vStackView.spacing = 15
            vStackView.translatesAutoresizingMaskIntoConstraints = false

            dayView.addSubview(vStackView)

            NSLayoutConstraint.activate([
                vStackView.leadingAnchor.constraint(equalTo: dayView.leadingAnchor, constant: 20),
                vStackView.trailingAnchor.constraint(equalTo: dayView.trailingAnchor, constant: -20),
                vStackView.topAnchor.constraint(equalTo: dayView.topAnchor, constant: 20),
                vStackView.bottomAnchor.constraint(equalTo: dayView.bottomAnchor, constant: -20),
            ])

            mainStackView.addArrangedSubview(dayView)

            dayView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                dayView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 0),
                dayView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 0)
            ])
            
            answerViews.append([answer1Label, answer2Label])
        }
    }

    private func calculations() {
        let queue = DispatchQueue(label: "com.AdventOfCode.queue")
        for index in 0..<answerViews.count {
            queue.async {
                let answer1 = self.presenter.calculate(year: 2016, day: index+1, question: 1)
                let answer2 = self.presenter.calculate(year: 2016, day: index+1, question: 2)
                DispatchQueue.main.async {
                    self.answerViews[index][0].text = answer1
                    self.answerViews[index][1].text = answer2
                }
            }
        }
    }
    
}
