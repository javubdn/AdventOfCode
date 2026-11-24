//
//  PulseModule.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 23/11/2026.
//

class PulseModule {
    
    enum ModuleType {
        case flipflop
        case conjunction
        case broadcast
    }
    
    let name: String
    var destiny: [String] = []
    var type: ModuleType?
    var isOn: Bool = false
    var memory: [String: Bool] = [:]
    
    init(name: String, type: ModuleType?) {
        self.name = name
        self.type = type
    }
    
}
