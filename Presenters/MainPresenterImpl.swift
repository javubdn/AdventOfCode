//
//  MainPresenterImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 2/12/21.
//

import Foundation

class MainPresenterImpl: MainPresenter {
    
    let interactor: MainInteractor
    let router: MainRouter
    
    init(interactor: MainInteractor, router: MainRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func calculate(year: Int,day: Int, question: Int) -> String {
        return interactor.calculate(year: year, day: day, question: question)
    }
    
    func openDetail(_ year: Year, _ day: Int) {
        router.openDetail(year, day)
    }
    
}
