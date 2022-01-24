//
//  MainPresenterImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 2/12/21.
//

import Foundation

class MainPresenterImpl: MainPresenter {
    
    let interactor: MainInteractor
    
    init(interactor: MainInteractor) {
        self.interactor = interactor
    }
    
    func calculate(year: Int,day: Int, question: Int) -> String {
        return interactor.calculate(year: year, day: day, question: question)
    }
    
}
