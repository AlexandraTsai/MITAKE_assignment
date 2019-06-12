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
    
    func transform() -> TickNum {
        
        guard let t = Int(self.t),
            let o = Double(self.o),
            let h = Double(self.h),
            let l = Double(self.l),
            let c = Double(self.c),
            let v = Int(self.v) else { return TickNum() }
        
        let tickNum = TickNum(t: t,
                              o: o,
                              h: h,
                              l: l,
                              c: c,
                              v: v)
       return tickNum
    }
}

struct TickNum {
    
    var t: Int = 0
    var o: Double = 0.0
    var h: Double = 0.0
    var l: Double = 0.0
    var c: Double = 0.0
    var v: Int = 0
    
}
