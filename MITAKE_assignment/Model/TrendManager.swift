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
    
    var trend: Trend? {
        
        didSet {
            
            if let trend = trend {
                
                arrayC = insertAllC(from: trend)
            }
            
        }
        
    }
    
    var arrayC = [Double]()
    
    init(fileName: String) {
        
        self.fileName = fileName
        
    }
    
    func readJsonFromFile() {
        
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
    
    func insertAllC(from trend: Trend) -> [Double] {
        
        let tick = trend.root.tick
        
        var arrayC = [Double]()
        
        for i in tick {
            
            if let insertNum = Double(i.c) {
                
                arrayC.append(insertNum)
            }
            
        }
        
        return arrayC
        
    }
    
}
