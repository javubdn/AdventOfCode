//
//  Stack.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 29/12/22.
//

struct Stack<T> {
    var array: [T] = []
    
    mutating func pop() -> T? {
        return array.removeLast()
    }
    
    
    func peek() -> T? {
    }
    
}
