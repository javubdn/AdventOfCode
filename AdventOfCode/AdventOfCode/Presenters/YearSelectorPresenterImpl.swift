//
//  YearSelectorPresenterImpl.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 9/12/21.
//

import Foundation

class YearSelectorPresenterImpl: YearSelectorPresenter {
    
    private var router: YearSelectorRouter
    
    init(router: YearSelectorRouter) {
        self.router = router
    }
    
    func navigateTo(year: Year) {
        router.navigateTo(year: year)
    }
    
}
