//
//  ThreadReplica.swift
//  CRDT
//
//  Created by Dominique d'Argent on 26.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

import Foundation

fileprivate let ThreadIdentifierDictionaryKey = UUID()

public struct ThreadReplica {
    private let threadIdentifier: UUID
    
    public static var current: ThreadReplica {
        if let threadIdentifier = Thread.current.threadDictionary[ThreadIdentifierDictionaryKey] as? UUID {
            return ThreadReplica(threadIdentifier: threadIdentifier)
        }
        
        let threadIdentifier = UUID()
        Thread.current.threadDictionary[ThreadIdentifierDictionaryKey] = threadIdentifier
        
        return ThreadReplica(threadIdentifier: threadIdentifier)
    }
}

extension ThreadReplica: Replica {
    public var uniqueIdentifier: AnyHashable {
        return threadIdentifier
    }
}

extension ThreadReplica: Hashable {
    public var hashValue: Int {
        return threadIdentifier.hashValue
    }
}

extension ThreadReplica: Equatable {
    public static func ==(lhs: ThreadReplica, rhs: ThreadReplica) -> Bool {
        return lhs.threadIdentifier == rhs.threadIdentifier
    }
}

extension ThreadReplica: CustomStringConvertible {
    public var description: String {
        return threadIdentifier.uuidString
    }
}

extension ThreadReplica: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "Replica(\(threadIdentifier))"
    }
}
