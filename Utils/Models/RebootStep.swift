//
//  RebootStep.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 6/10/22.
//
import Foundation
class RebootStep {
            volumes.append(contentsOf: volumes.compactMap { $0.intersect(cube) })
            if cube.on { volumes.append(cube) }
        }
        return volumes.map { $0.volume() }.reduce(0, +)
    }
    
}
