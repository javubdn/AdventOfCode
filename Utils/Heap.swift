//
//  Heap.swift
//  AdventOfCode
//
//  Created by Javier Castillo on 28/11/22.
//

struct Heap<Element> {
    var elements: [Element]
    let priorityFunction: (Element, Element) -> Bool

    var isEmpty: Bool {
        elements.isEmpty
    }

    var count: Int {
        elements.count
    }
    
}
