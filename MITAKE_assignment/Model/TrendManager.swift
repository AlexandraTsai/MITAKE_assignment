//
//  TrendManager.swift
//  MITAKE_assignment
//
//  Created by 蔡佳宣 on 2019/6/10.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import Foundation

class TrendManager {
    
    var fileName: String
    
    var trend: Trend?
    
    init(fileName: String) {
        
        self.fileName = fileName
        
    }
    
    func getTrend() {
        
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            
            do {
                
                let fileUrl = URL(fileURLWithPath: path)
                
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                
                trend = try JSONDecoder().decode(Trend.self, from: data)
                
            } catch {
                
                print("unable to find json data")
                
            }
            
        }
        
    }
    
    func getCenter(from trend: Trend) -> [Double] {
        
        let tick = trend.root.tick
        
        var arrayC = [Double]()
        
        for i in tick {
            
            if let insertNum = Double(i.c) {
                
                arrayC.append(insertNum)
            }
            
        }
        
        return arrayC
        
    }
    
    func getTime(from trend: Trend) -> [Int] {
        
        let tick = trend.root.tick
        
        var arrayT = [Int]()
        
        for i in tick {
            
            let insertNum = Int(i.t)
            
            if let insertNum = insertNum {
                
                arrayT.append(insertNum)
            }
            
        }
        
        return arrayT
        
    }
    
    func getLPrice(from trend: Trend) -> [Double] {
        
        let tick = trend.root.tick
        
        var arrayL = [Double]()
        
        for i in tick {
            
            if let insertNum = Double(i.l) {
                
                arrayL.append(insertNum)
            }
            
        }
        
        return arrayL
        
    }
    
    func getHPrice(from trend: Trend) -> [Double] {
        
        let tick = trend.root.tick
        
        var arrayH = [Double]()
        
        for i in tick {
            
            if let insertNum = Double(i.h) {
                
                arrayH.append(insertNum)
            }
            
        }
        
        return arrayH
        
    }
    
    func getVolume(from trend: Trend) -> [Int] {
        
        let tick = trend.root.tick
        
        var arrayV = [Int]()
        
        for i in tick {
            
            let insertNum = Int(i.v)
            
            if let insertNum = insertNum {
                
                arrayV.append(insertNum)
            }
            
        }
        
        return arrayV
        
    }
    
    func getTick() -> [TickNum] {
        
        var tickNum = [TickNum]()
        
        guard let tick = trend?.root.tick else { return tickNum }
        
        for i in tick {
            
            let tickToAppend = i.transform()
         
            tickNum.append(tickToAppend)
            
        }
        
        return tickNum
        
    }
    
}
