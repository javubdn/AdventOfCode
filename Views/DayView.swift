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
