//
//  CvRDT.swift
//  CRDT
//
//  Created by Dominique d'Argent on 24.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

public protocol CvRDT: JoinSemiLattice {
    associatedtype Value
    
    var value: Value { get }
}

public protocol AnonymousCvRDT: CvRDT {
}

public protocol NamedCvRDT: CvRDT {
    init(localReplica: Replica)
    init(named: String)
}

extension NamedCvRDT {
    public init(named name: String) {
        let replica = NamedReplica(name)
        
        self.init(localReplica: replica)
    }
}

public protocol CausalCvRDT: CvRDT {
}
