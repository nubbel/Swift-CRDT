//
//  Flag.swift
//  CRDT
//
//  Created by Dominique d'Argent on 24.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

public struct Flag {
    private var state = false
}

// MARK: - Mutations

extension Flag {
    public mutating func set() {
        state = true
    }
}

// MARK: - Anonymous CvRDT
extension Flag: AnonymousCvRDT {
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
