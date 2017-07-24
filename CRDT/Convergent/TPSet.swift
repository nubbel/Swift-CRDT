//
//  TPSet.swift
//  CRDT
//
//  Created by Dominique d'Argent on 24.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

// 2P-Set (Two-Phase Set)
public struct TPSet<Element: Hashable> {
    private let localReplica: Replica
    private var addSet: GSet<Element>
    private var removeSet: GSet<Element>
    
    public init(localReplica: Replica) {
        self.localReplica = localReplica
        addSet = GSet(localReplica: localReplica)
        removeSet = GSet(localReplica: localReplica)
    }
    
    public mutating func add(_ element: Element) {
        addSet.add(element)
    }
    
    public mutating func remove(_ element: Element) {
        removeSet.add(element)
    }
}

extension TPSet: CvRDT {
    public var value: Set<Element> {
        return addSet.value.subtracting(removeSet.value)
    }
    
    public mutating func join(other: TPSet<Element>) {
        addSet.join(other: other.addSet)
        removeSet.join(other: other.removeSet)
    }
    
    public static func <=(lhs: TPSet<Element>, rhs: TPSet<Element>) -> Bool {
        return lhs.addSet <= rhs.addSet && lhs.removeSet <= rhs.removeSet
    }
}

extension TPSet: Sequence {
    public func makeIterator() -> SetIterator<Element> {
        return value.makeIterator()
    }
}

