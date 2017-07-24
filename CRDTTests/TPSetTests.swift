//
//  TPSetTests.swift
//  CRDTTests
//
//  Created by Dominique d'Argent on 24.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

import XCTest
@testable import CRDT

class TPSetTests: XCTestCase {
    
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
        
        // add is idemptotent
        set.add(3)
        XCTAssertEqual(set.value, [1, 2, 3])
    }
    
    func testRemove() {
        var set = newSet()
        
        set.remove(1)
        XCTAssertEqual(set.value, Set())
        
        set.remove(2)
        XCTAssertEqual(set.value, Set())
    }
    
    func testAddAndRemove() {
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
        
        set.remove(2)
        XCTAssertEqual(set.value, [1, 3])
        
        // remove is idempotent
        set.remove(2)
        XCTAssertEqual(set.value, [1, 3])
        
        // once removed, an element cannot be added again
        set.add(2)
        XCTAssertEqual(set.value, [1, 3])
    }
    
    func testJoin() {
        var a = newSet("a")                         // A: {}, R: {}
        var b = newSet("b")                         // A: {}, R: {}
        
        a.add(1)                                    // A: {1}, R: {}
        a.add(2)                                    // A: {1, 2}, R: {}
        
        b.remove(2)                                 // A: {}, R: {}
        b.add(3)                                    // A: {3}, R: {2}
        
        let join = a.joining(other: b)              // A: {1, 2, 3}, R: {2}
        XCTAssertEqual(join.value, [1, 3])
        
        // join is least upper bound of a and b
        XCTAssert(a <= join)
        XCTAssert(b <= join)
        
        a.join(other: b)                            // A: {1, 2, 3}, R: {2}
        b.join(other: a)                            // A: {1, 2, 3}, R: {2}
        
        XCTAssert(a <= b)
        XCTAssert(b <= a)
    }
    
    func testPartiallyOrdered() {
        var a = newSet("a")                         // A: {}, R: {}
        var b = newSet("b")                         // A: {}, R: {}
        
        XCTAssert(a <= b)
        XCTAssert(b <= a)
        
        a.add(1)                                    // A: {1}, R: {}
        
        XCTAssertFalse(a <= b)
        XCTAssert(b <= a)
        
        b.remove(2)                                 // A: {}, R: {2}
        
        XCTAssertFalse(a <= b)
        XCTAssertFalse(b <= a)
        
        b.join(other: a)                            // A: {1}, R: {2}
        
        XCTAssert(a <= b)
        XCTAssertFalse(b <= a)
        
        a.join(other: b)                            // A: {1}, R: {2}
        
        XCTAssert(a <= b)
        XCTAssert(b <= a)
    }
    
    func testSequence() {
        var set = newSet()
        set.remove(2)
        set.add(1)
        set.add(2)
        set.add(3)
        set.remove(3)
        set.add(4)
        set.add(5)
        set.remove(4)
        set.add(4)
        
        XCTAssertEqual(Set(set), [1, 5])
    }
    
}

fileprivate func newSet(_ name: String = "test") -> TPSet<Int> {
    let replica = Replica(named: name)
    
    return TPSet(localReplica: replica)
}
