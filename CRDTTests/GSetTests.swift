//
//  GSetTests.swift
//  CRDTTests
//
//  Created by Dominique d'Argent on 24.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

import XCTest
@testable import CRDT

class GSetTests: XCTestCase {
    
    func testInitialValue() {
        let set = newSet()
        
        XCTAssertEqual(set.value, Set())
    }
    
    func testAdd() {
        var set = newSet()
        
        set.add(1)
        XCTAssertEqual(set.value, [1])
        
        set.add(2)
        XCTAssertEqual(set.value, [1, 2])
        
        set.add(3)
        XCTAssertEqual(set.value, [1, 2, 3])
        
        // add is idempotent
        set.add(3)
        XCTAssertEqual(set.value, [1, 2, 3])
    }
    
    func testJoin() {
        var a = newSet("a")                     // {}
        var b = newSet("b")                     // {}
        
        a.add(1)                                // {1}
        b.add(2)                                // {2}
        
        let join = a.joining(other: b)          // {1, 2}
        XCTAssertEqual(join.value, [1, 2])
        
        // join is least upper bound (LUB) of a and b
        XCTAssert(a <= join)
        XCTAssert(b <= join)
        
        a.join(other: b)                        // {1, 2}
        b.join(other: a)                        // {1, 2}
        
        XCTAssert(a <= b)
        XCTAssert(b <= a)
    }
    
    func partiallyOrdered() {
        var a = newSet("a")                     // {}
        var b = newSet("b")                     // {}
        
        XCTAssert(a <= b)
        XCTAssert(b <= a)
        
        a.add(1)                                // {1}
        
        XCTAssertFalse(a <= b)
        XCTAssert(b <= a)
        
        b.add(1)                                // {1}
        b.add(2)                                // {1, 2}
        
        XCTAssertFalse(a <= b)
        XCTAssertFalse(b <= a)
        
        a.join(other: b)                        // {1, 2}
        
        XCTAssertFalse(a <= b)
        XCTAssert(b <= a)
        
        b.join(other: a)                        // {1, 2}
        
        XCTAssert(a <= b)
        XCTAssert(b <= a)
    }
    
    func testSequence() {
        var set = newSet()
        set.add(1)
        set.add(2)
        set.add(3)
        set.add(4)
        set.add(5)
        
        XCTAssertEqual(Set(set), [1, 2, 3, 4, 5])
    }
}

fileprivate func newSet(_ name: String = "test") -> GSet<Int> {
    let replica = Replica(named: name)
    
    return GSet(localReplica: replica)
}
