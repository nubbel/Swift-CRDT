//
//  Replica.swift
//  CRDT
//
//  Created by Dominique d'Argent on 24.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

public protocol Replica {
    var uniqueIdentifier: AnyHashable { get }
}
