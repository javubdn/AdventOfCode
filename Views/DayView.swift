//
//  DayView.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 23/6/22.
//

import UIKit

protocol DayViewDelegate {
    func openDetail(_ year: Year, _ day: Int)
}

class DayView: UIView {
    
    private var answer1Label: UILabel
    private var answer2Label: UILabel
    private let delegate: DayViewDelegate?
    private let year: Year
    private var day: Int
    
    init(_ year: Year, _ day: Int, _ mainStackView: UIStackView, _ delegate: DayViewDelegate) {
        answer1Label = UILabel()
        answer2Label = UILabel()
        self.delegate = delegate
        self.year = year
        self.day = day
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        layer.borderWidth = 2
        layer.borderColor = .init(red: 0, green: 0.2, blue: 0.7, alpha: 1)
        layer.cornerRadius = 5

        let titleDayLabel = UILabel()
        titleDayLabel.text = "Día \(day + 1)"
        titleDayLabel.textAlignment = .center
        titleDayLabel.font = UIFont(name: "Futura-Medium", size: 20.0)

        let question1Label = UILabel()
        question1Label.text = "Primera parte"
        question1Label.textAlignment = .left
        
        answer1Label.text = "Calculando..."
        answer1Label.textAlignment = .right
        
        let q1StackView = UIStackView(arrangedSubviews: [question1Label, answer1Label])
        q1StackView.axis = .horizontal
        q1StackView.spacing = 15

        let question2Label = UILabel()
        question2Label.text = "Segunda parte"
        question2Label.textAlignment = .left

        answer2Label.text = "Calculando..."
        answer2Label.textAlignment = .right

        let q2StackView = UIStackView(arrangedSubviews: [question2Label, answer2Label])
        q2StackView.axis = .horizontal
        q2StackView.spacing = 15

        let vStackView = UIStackView(arrangedSubviews: [titleDayLabel, q1StackView, q2StackView])
        vStackView.axis = .vertical
        vStackView.spacing = 15
        vStackView.translatesAutoresizingMaskIntoConstraints = false

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickSection(_:))))
        
        addSubview(vStackView)
        
        NSLayoutConstraint.activate([
            vStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            vStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            vStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            vStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
        mainStackView.addArrangedSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 0),
            trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: 0)
        ])
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        answer1Label = UILabel()
        answer2Label = UILabel()
        delegate = nil
        year = .fifteen
        day = 0
        super.init(coder: aDecoder)
    }
    
    func setAnswers(_ answers: (String, String)) {
        answer1Label.text = answers.0
        answer2Label.text = answers.1
    }
    
    @objc
    func clickSection(_ sender: UITapGestureRecognizer) {
        delegate?.openDetail(year, day)
    }
    
}
