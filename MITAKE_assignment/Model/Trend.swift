//
//  Data.swift
//  MITAKE_assignment
//
//  Created by 蔡佳宣 on 2019/6/10.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import Foundation

struct Trend: Codable {
    
    var root: Root
    
}

struct Root: Codable {
    var rc: String
    var cnts: String
    var stk: String
    var c: String
    var tp: String
    var bp: String
    var v: String
    var tt: String
    var st: String
    var tick: [Tick]
}

struct Tick: Codable {
    var t: String
    var o: String
    var h: String
    var l: String
    var c: String
    var v: String
}
