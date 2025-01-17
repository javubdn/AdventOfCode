//
//  MainPresenter.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 2/12/21.
//

import Foundation

protocol MainPresenter {
    
    func calculate(year: Year, day: Int, question: Int) -> String
    func openDetail(_ year: Year, _ day: Int)
    
}
