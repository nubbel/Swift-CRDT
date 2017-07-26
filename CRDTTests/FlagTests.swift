//
//  FlagTests.swift
//  CRDTTests
//
//  Created by Dominique d'Argent on 24.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

import XCTest
@testable import CRDT


class FlagTests: XCTestCase {
    
    func testInitialValue() {
        let flag = newFlag()
        
        XCTAssertEqual(flag.value, false)
    }
    
    func testSet() {
        var flag = newFlag()
        
        flag.set()
        XCTAssertEqual(flag.value, true)
        
        // set is idempotent
        flag.set()
        XCTAssertEqual(flag.value, true)
    }
    
    func testJoinFalseFalse() {
        var a = newFlag()               // false
        var b = newFlag()               // false
        
        let join = a.joining(other: b)  // false
        XCTAssertEqual(join.value, false)
        
        // join is least upper bound (LUB) of a and b
        XCTAssert(a <= join)
        XCTAssert(b <= join)
        
        a.join(other: b)                // false
        b.join(other: a)                // false
        
        XCTAssertEqual(a.value, b.value)
    }
    
    func testJoinTrueFalse() {
        var a = newFlag()               // false
        var b = newFlag()               // false
        
        a.set()                         // true
        
        let join = a.joining(other: b)  // true
        XCTAssertEqual(join.value, true)
        
        // join is least upper bound (LUB) of a and b
        XCTAssert(a <= join)
        XCTAssert(b <= join)
        
        a.join(other: b)                // true
        b.join(other: a)                // true
        
        XCTAssertEqual(a.value, b.value)
    }
    
    func testJoinFalseTrue() {
        var a = newFlag()               // false
        var b = newFlag()               // false
        
        b.set()                         // true
        
        let join = a.joining(other: b)  // true
        XCTAssertEqual(join.value, true)
        
        // join is least upper bound (LUB) of a and b
        XCTAssert(a <= join)
        XCTAssert(b <= join)
        
        a.join(other: b)                // true
        b.join(other: a)                // true
        
        XCTAssertEqual(a.value, b.value)
    }
    
    func testJoinTrueTrue() {
        var a = newFlag()               // false
        var b = newFlag()               // false
        
        a.set()                         // true
        b.set()                         // true
        
        let join = a.joining(other: b)  // true
        XCTAssertEqual(join.value, true)
        
        // join is least upper bound (LUB) of a and b
        XCTAssert(a <= join)
        XCTAssert(b <= join)
        
        a.join(other: b)                // true
        b.join(other: a)                // true
        
        XCTAssertEqual(a.value, b.value)
    }
    
    func testPartiallyOrdered() {
        var a = newFlag()               // false
        var b = newFlag()               // false
        
        XCTAssert(a <= b)
        XCTAssert(b <= a)
        
        a.set()                         // true
        
        XCTAssertFalse(a <= b)
        XCTAssert(b <= a)
        
        a.join(other: b)                // true
        
        XCTAssertFalse(a <= b)
        XCTAssert(b <= a)
        
        b.set()                         // true
        
        XCTAssert(a <= b)
        XCTAssert(b <= a)
    }
    
}

// MARK: - Util
fileprivate func newFlag() -> Flag {
    return Flag()
}
