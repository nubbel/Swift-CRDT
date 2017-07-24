//
//  Flag.swift
//  CRDT
//
//  Created by Dominique d'Argent on 24.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

public struct Flag {
    private let localReplica: Replica
    private var state = false
    
    public init(localReplica: Replica) {
        self.localReplica = localReplica
    }
    
    public mutating func set() {
        state = true
    }
}

extension Flag: CvRDT {
    public var value: Bool {
        return state
    }
    
    public mutating func join(other: Flag) {
        state = state || other.state
    }
    
    public static func <=(lhs: Flag, rhs: Flag) -> Bool {
        return !lhs.state || rhs.state
    }
    
    
}
