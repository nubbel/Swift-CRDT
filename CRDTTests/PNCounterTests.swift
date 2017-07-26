//
//  PNCounterTests.swift
//  CRDTTests
//
//  Created by Dominique d'Argent on 24.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

import XCTest
@testable import CRDT

class PNCounterTests: XCTestCase {
    
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
    
    func testDecrement() {
        var counter = newCounter()
        
        counter.decrement()
        XCTAssertEqual(counter.value, -1)
        
        counter.decrement()
        XCTAssertEqual(counter.value, -2)
        
        counter.decrement(by: 3)
        XCTAssertEqual(counter.value, -5)
    }
    
    func testIncrementAndDecrement() {
        var counter = newCounter()
        
        counter.increment(by: 5)
        XCTAssertEqual(counter.value, 5)
        
        counter.decrement(by: 2)
        XCTAssertEqual(counter.value, 3)
    }
    
    func testJoin() {
        var a = newCounter("a")                 // P: 0, N: 0
        var b = newCounter("b")                 // P: 0, N: 0
        
        a.increment(by: 5)                      // P: 5, N: 0
        b.decrement(by: 2)                      // P: 0, N: 2
        
        let join = a.joining(other: b)          // P: 5, N: 2
        XCTAssertEqual(join.value, 3)
        
        // join is least upper bound (LUB) of a and b
        XCTAssert(a <= join)
        XCTAssert(b <= join)
        
        a.join(other: b)                        // P: 5, N: 2
        b.join(other: a)                        // P: 5, N: 2
        
        XCTAssertEqual(a.value, b.value)
    }
    
    func testPartiallyOrdered() {
        var a = newCounter("a")                 // P: [], N: []
        var b = newCounter("b")                 // P: [], N: []
        
        XCTAssert(a <= b)
        XCTAssert(b <= a)
        XCTAssertFalse(a.isConcurrent(to: b))
        XCTAssertFalse(b.isConcurrent(to: a))
        
        a.increment()                           // P: [a: 1], N: []
        
        XCTAssertFalse(a <= b)
        XCTAssert(b <= a)
        XCTAssertFalse(a.isConcurrent(to: b))
        XCTAssertFalse(b.isConcurrent(to: a))
        
        b.increment()                           // P: [b: 1], N: []
        
        XCTAssertFalse(a <= b)
        XCTAssertFalse(b <= a)
        XCTAssert(a.isConcurrent(to: b))
        XCTAssert(b.isConcurrent(to: a))

        a.join(other: b)                        // P: [a: 1, b: 1], N: []
        
        XCTAssertFalse(a <= b)
        XCTAssert(b <= a)
        XCTAssertFalse(a.isConcurrent(to: b))
        XCTAssertFalse(b.isConcurrent(to: a))
        
        a.decrement()                           // P: [a: 1, b: 1], N: [a: 1]
        
        XCTAssertFalse(a <= b)
        XCTAssert(b <= a)
        XCTAssertFalse(a.isConcurrent(to: b))
        XCTAssertFalse(b.isConcurrent(to: a))
        
        b.join(other: a)                        // P: [a: 1, b: 1], N: [a: 1]
        
        XCTAssert(a <= b)
        XCTAssert(b <= a)
        XCTAssertFalse(a.isConcurrent(to: b))
        XCTAssertFalse(b.isConcurrent(to: a))
    }
    
}

// MARK: - Util
fileprivate func newCounter(_ name: String = "test") -> PNCounter {
    return PNCounter(named: name)
}
