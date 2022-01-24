//
//  MainInteractorImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 2/12/21.
//

import Foundation

class MainInteractorImpl: NSObject {
    
}

extension MainInteractorImpl: MainInteractor {
    
    func calculate(year: Int, day: Int, question: Int) -> String {
        let interactor: YearInteractor
        switch year {
        case 2015:
            interactor = Year2015InteractorImpl()
        case 2016:
            interactor = Year2016InteractorImpl()
        case 2021:
            interactor = Year2021InteractorImpl()
        default:
            interactor = Year2021InteractorImpl()
        }
        
        return interactor.calculate(day: day, question: question)
    }
    
}

