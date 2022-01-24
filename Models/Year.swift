//
//  Year.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 10/12/21.
//

import Foundation

enum Year {
    case fifteen
    case sixteen
    case twentyOne
    case twenty
    
    func value() -> Int {
        switch self {
        case .fifteen:
            return 2015
        case .sixteen:
            return 2016
        case .twenty:
            return 2020
        case .twentyOne:
            return 2021
        }
    }
}
