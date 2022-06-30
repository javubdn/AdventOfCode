//
//  MainInteractor.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 2/12/21.
//

import Foundation

protocol MainInteractor {
    
    func calculate(year: Year, day: Int, question: Int) -> String
    
}
