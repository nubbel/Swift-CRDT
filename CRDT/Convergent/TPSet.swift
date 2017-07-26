//
//  TPSet.swift
//  CRDT
//
//  Created by Dominique d'Argent on 24.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

// 2P-Set (Two-Phase Set)
public struct TPSet<Element: Hashable> {
    private var addSet = GSet<Element>()
    private var removeSet = GSet<Element>()
}

// MARK: - Queries
extension TPSet {
    func contains(_ element: Element) -> Bool {
        return addSet.contains(element) && !removeSet.contains(element)
    }
}

// MARK: - Mutations
extension TPSet {
    public mutating func add(_ element: Element) {
        addSet.add(element)
    }
    
    public mutating func remove(_ element: Element) {
        removeSet.add(element)
    }
}

// MARK: - Anonymous CvRDT
extension TPSet: AnonymousCvRDT {
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

