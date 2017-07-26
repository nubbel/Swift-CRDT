//
//  NamedReplica.swift
//  CRDT
//
//  Created by Dominique d'Argent on 25.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

public struct NamedReplica {
    private let name: String
    
    public init(_ name: String) {
        self.name = name
    }
}

extension NamedReplica: Replica {
    public var uniqueIdentifier: AnyHashable {
        return name
    }
}

extension NamedReplica: Hashable {
    public var hashValue: Int {
        return name.hashValue
    }
}

extension NamedReplica: Equatable {
    public static func ==(lhs: NamedReplica, rhs: NamedReplica) -> Bool {
        return lhs.name == rhs.name
    }
}

extension NamedReplica: CustomStringConvertible {
    public var description: String {
        return name
    }
}

extension NamedReplica: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Replica(\(name))"
    }
}
