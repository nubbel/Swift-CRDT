//
//  PNCounter.swift
//  CRDT
//
//  Created by Dominique d'Argent on 24.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

public struct PNCounter {
    private let localReplica: Replica
    private var pCounter: GCounter
    private var nCounter: GCounter
    
    public init(localReplica: Replica) {
        self.localReplica = localReplica
        pCounter = GCounter(localReplica: localReplica)
        nCounter = GCounter(localReplica: localReplica)
    }
    
    public mutating func increment(by value: Int = 1) {
        pCounter.increment(by: value)
    }
    
    public mutating func decrement(by value: Int = 1) {
        nCounter.increment(by: value)
    }
}

extension PNCounter: CvRDT {
    public var value: Int {
        return pCounter.value - nCounter.value
    }
    
    public mutating func join(other: PNCounter) {
        pCounter.join(other: other.pCounter)
        nCounter.join(other: other.nCounter)
    }
    
    public static func <=(lhs: PNCounter, rhs: PNCounter) -> Bool {
        return lhs.pCounter <= rhs.pCounter && lhs.nCounter <= rhs.nCounter
    }
    
    
}
