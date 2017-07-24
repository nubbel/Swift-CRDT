//
//  Replica.swift
//  CRDT
//
//  Created by Dominique d'Argent on 24.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

public struct Replica {
    private let name: String
    
    public init(named name: String) {
        self.name = name
    }
}

extension Replica: Hashable {
    public var hashValue: Int {
        return name.hashValue
    }
}

extension Replica: Equatable {
    public static func ==(lhs: Replica, rhs: Replica) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Replica: CustomStringConvertible {
    public var description: String {
        return name
    }
}

extension Replica: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Replica(\(name))"
    }
}
