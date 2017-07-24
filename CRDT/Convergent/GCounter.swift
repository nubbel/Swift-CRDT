//
//  GCounter.swift
//  CRDT
//
//  Created by Dominique d'Argent on 24.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

public struct GCounter {
    private let localReplica: Replica
    private var state = [Replica: Int]()
    
    public init(localReplica: Replica) {
        self.localReplica = localReplica
    }
    
    public mutating func increment(by value: Int = 1) {
        state.incrementValue(forKey: localReplica, by: value)
    }
}

extension GCounter: CvRDT {
    public var value: Int {
        return state.values.reduce(0, +)
    }
    
    public mutating func join(other: GCounter) {
        state.merge(other.state) { max($0, $1) }
    }
    
    public static func <=(lhs: GCounter, rhs: GCounter) -> Bool {
        for replica in Set(lhs.state.keys).intersection(lhs.state.keys) {
            guard lhs.state[replica, default: 0] <= rhs.state[replica, default: 0] else {
                return false
            }
        }
        
        return true
    }
}
