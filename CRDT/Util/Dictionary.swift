//
//  Dictionary.swift
//  CRDT
//
//  Created by Dominique d'Argent on 24.07.17.
//  Copyright © 2017 Dominique d'Argent. All rights reserved.
//

extension Dictionary where Value == Int {
    public mutating func incrementValue(forKey key: Key, by value: Int = 1) {
        self[key] = self[key, default: 0] + value
    }
}
