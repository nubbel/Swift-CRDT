//
//  ThreadReplicaTests.swift
//  CRDTTests
//
//  Created by Dominique d'Argent on 26.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

import XCTest
@testable import CRDT

class ThreadReplicaTests: XCTestCase {
    
    func testSingleThread() {
        let a = ThreadReplica.current
        let b = ThreadReplica.current
        
        XCTAssertEqual(a, b)
    }
    
    func testMultipleThreads() {
        let a = ThreadReplica.current
        
        let threadExpectation = expectation(description: "other thread")
        Thread.detachNewThread {
            autoreleasepool {
                let b = ThreadReplica.current
                XCTAssertNotEqual(b, a)
                
                threadExpectation.fulfill()
            }
        }
        
        wait(for: [threadExpectation], timeout: 0.1)
    }
    
}
