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
    
    func calculate(year: Year, day: Int, question: Int) -> String {
        let interactor: YearInteractor
        switch year {
        case .fifteen: interactor = Year2015InteractorImpl()
        case .sixteen: interactor = Year2016InteractorImpl()
        case .seventeen: interactor = Year2017InteractorImpl()
        case .eighteen: interactor = Year2018InteractorImpl()
        case .nineteen: interactor = Year2019InteractorImpl()
        case .twenty: interactor = Year2020InteractorImpl()
        case .twentyOne: interactor = Year2021InteractorImpl()
        case .twentyTwo: interactor = Year2022InteractorImpl()
        }
        
        return interactor.calculate(day: day, question: question)
    }
    
}

