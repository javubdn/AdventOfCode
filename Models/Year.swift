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
    case seventeen
    case eighteen
    case nineteen
    case twenty
    case twentyOne
    case twentyTwo
    
    func value() -> Int {
        switch self {
        case .fifteen:
            return 2015
        case .sixteen:
            return 2016
        case .seventeen:
            return 2017
        case .eighteen:
            return 2018
        case .nineteen:
            return 2019
        case .twenty:
            return 2020
        case .twentyOne:
            return 2021
        case .twentyTwo:
            return 2022
        }
    }
}
