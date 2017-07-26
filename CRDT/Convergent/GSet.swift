//
//  GSet.swift
//  CRDT
//
//  Created by Dominique d'Argent on 24.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

struct GSet<Element: Hashable> {
    private var state = Set<Element>()
    
    public mutating func add(_ element: Element) {
        state.insert(element)
    }
}

extension GSet: AnonymousCvRDT {
    public var value: Set<Element> {
        return state
    }
    
    public mutating func join(other: GSet<Element>) {
        state.formUnion(other.state)
    }
    
    public static func <=(lhs: GSet<Element>, rhs: GSet<Element>) -> Bool {
        return lhs.state.isSubset(of: rhs.state)
    }
}

extension GSet: Sequence {
    public func makeIterator() -> SetIterator<Element> {
        return value.makeIterator()
    }
}
