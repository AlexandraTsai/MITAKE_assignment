//
//  ViewController.swift
//  MITAKE_assignment
//
//  Created by 蔡佳宣 on 2019/6/10.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let alTrendView = ALTrendView()
    
    let alVolumeView = ALVolumeView()
    
    var trendManager = TrendManager(fileName: "trend_2201")
    
    var tick = [TickNum]()
    
    var trend: Trend?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTrendView()
        
        setupVolumeView()
        
    }
    
    func setupTrendView() {
        
        alTrendView.frame = CGRect(x: 20,
                                   y: 50,
                                   width: UIScreen.main.bounds.width-60,
                                   height: 300)
        
        alTrendView.backgroundColor = UIColor.black
        
        self.view.addSubview(alTrendView)
        
        trendManager.getTrend()
        
        trend = trendManager.trend

        tick = trendManager.getTick()
        
        guard let trend = trend  else { return }
            
        if let startTime = trend.root.tick.first?.t,
           let endTime = trend.root.tick.last?.t {
            
            alTrendView.showTrendWith(startTime: startTime,
                                      endTime: endTime,
                                      tp: trend.root.tp,
                                      bp: trend.root.bp,
                                      c: trend.root.c,
                                      tick: tick)

        }
        
    }
    
    func setupVolumeView() {
        
        alVolumeView.frame = CGRect(x: alTrendView.frame.origin.x,
                                    y: alTrendView.bounds.height + alTrendView.frame.origin.y + 10,
                                    width: UIScreen.main.bounds.width-60,
                                    height: 150)
        
        alVolumeView.backgroundColor = UIColor.clear
        
        self.view.addSubview(alVolumeView)
        
        if let st = trend?.root.st {
            
            if let st = Int(st) {
              
                alVolumeView.showVolumeWith(st: st, tick: tick)

            }
        }
        
    }
   
}

