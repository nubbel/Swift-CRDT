//
//  GSet.swift
//  CRDT
//
//  Created by Dominique d'Argent on 24.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

struct GSet<Element: Hashable> {
    private let localReplica: Replica
    private var state = Set<Element>()
    
    public init(localReplica: Replica) {
        self.localReplica = localReplica
    }
    
    public mutating func add(_ element: Element) {
        state.insert(element)
    }
}

extension GSet: CvRDT {
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
