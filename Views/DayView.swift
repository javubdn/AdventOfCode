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
    init(_ year: Year, _ day: Int, _ mainStackView: UIStackView, _ delegate: DayViewDelegate) {


        
        

        question2Label.text = "Segunda parte"

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
