//
//  GCounterTests.swift
//  CRDTTests
//
//  Created by Dominique d'Argent on 24.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

import XCTest
@testable import CRDT

class GCounterTests: XCTestCase {
    
    func testInitialValue() {
        let counter = newCounter()
        
        XCTAssertEqual(counter.value, 0)
    }
    
    func testIncrement() {
        var counter = newCounter()
        
        counter.increment()
        XCTAssertEqual(counter.value, 1)
        
        counter.increment()
        XCTAssertEqual(counter.value, 2)
        
        counter.increment(by: 3)
        XCTAssertEqual(counter.value, 5)
    }
    
    func testJoin() {
        var a = newCounter("a")         // []
        var b = newCounter("b")         // []
        
        a.increment()                   // [a: 1]
        a.increment()                   // [a: 2]
        
        b.increment()                   // [b: 1]
        
        let join = a.joining(other: b)  // [a: 2, b: 1]
        XCTAssertEqual(join.value, 3)
        
        // join is least upper bound (LUB) of a and b
        XCTAssert(a <= join)
        XCTAssert(b <= join)
        
        a.join(other: b)                // [a: 2, b: 1]
        b.join(other: a)                // [a: 2, b: 1]
        
        XCTAssertEqual(a.value, b.value)
    }
    
    func testPartiallyOrdered() {
        var a = newCounter("a")         // []
        var b = newCounter("b")         // []
        
        XCTAssert(a <= b)
        XCTAssert(b <= a)
        
        a.increment()                   // [a: 1]
        
        XCTAssertFalse(a <= b)
        XCTAssert(b <= a)
        
        b.increment()                   // [b: 1]
        
        XCTAssertFalse(a <= b)
        XCTAssertFalse(b <= a)
        
        a.join(other: b)                // [a: 1, b:1]
        
        XCTAssertFalse(a <= b)
        XCTAssert(b <= a)
        
        b.join(other: a)                // [a: 1, b: 1]
        
        XCTAssert(a <= b)
        XCTAssert(b <= a)
        
        b.increment()                   // [a: 1, b: 2]
        
        XCTAssert(a <= b)
        XCTAssertFalse(b <= a)
    }
    
}


// MARK: - Util
fileprivate func newCounter(_ name: String = "test") -> GCounter {
    let replica = Replica(named: name)
    
    return GCounter(localReplica: replica)
}
