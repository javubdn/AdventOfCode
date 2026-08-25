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


        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clickSection(_:))))
        
        addSubview(vStackView)
        
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
