//
//  ViewController.swift
//  MITAKE_assignment
//
//  Created by 蔡佳宣 on 2019/6/10.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var volumeView: UIView!
    
    @IBOutlet weak var volumeLabelView: UIView!
    
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var tpLabel: UILabel!
    
    @IBOutlet weak var cLabel: UILabel!
    
    @IBOutlet weak var bpLabel: UILabel!
    
    let alTrendView = ALTrendView()
    
    var trendManager = TrendManager(fileName: "trend_2201")
    
    var arrayC = [Double]()
    
    var arrayT = [Int]()
    
    var arrayH = [Double]()
    
    var arrayL = [Double]()
    
    var arrayV = [Int]()
    
    var tick = [TickNum]()
    
    var trend: Trend? {
        
        didSet {
            
            if let trend = trend {
                
                setupDate(from: trendManager, trend: trend)
               
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTrendView()
 
//        drawVolumeSquare()
//
//        addPriceLabel()
//
//        addVolumeLabel()
//
//        addTimeLabel()
//
//        drawVolume()
        
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
        
        if let trend = trend {
           
            alTrendView.showWith(trend: trend, tick: tick)

        }
        
    }
   
//    func drawVolume() {
//
//        let volumePath = UIBezierPath()
//
//        let layer = CAShapeLayer()
//
//        guard let max = arrayV.max(),
//            let startTime = arrayT.first,
//            let endTime = arrayT.last else { return }
//
//        let yRatio = volumeView.bounds.height/CGFloat(max)
//
//        let xRatio = Double(trendView.bounds.width)/Double(endTime - startTime + 1)
//
//        let arrayX = arrayT.map{ ( Double($0) * xRatio) }
//
//        let arrayY = arrayV.map{ Double($0) * Double(yRatio)}
//
//        for i in 0..<arrayY.count {
//
//            volumePath.move(to: CGPoint(x: Int(arrayX[i]), y: Int(volumeView.bounds.height)))
//
//            volumePath.addLine(to: CGPoint(x: Int(arrayX[i]), y: Int(volumeView.bounds.height) - Int(arrayY[i])))
//
//        }
//
//        layer.strokeColor = UIColor(red: 85/255, green: 162/255, blue: 214/255, alpha: 1).cgColor
//
//        layer.lineWidth = 0.6
//
//        layer.path = volumePath.cgPath
//
//        volumeView.layer.addSublayer(layer)
//
//    }
    
    func drawVolumeSquare() {
        
        guard let startTime = arrayT.first,
            let endTime = arrayT.last else { return }
        
        let section = (endTime - startTime + 1)/60
        
        let squarePath = UIBezierPath()
        
        let squareLayer = CAShapeLayer()
        
        //Draw border
        squarePath.move(to: CGPoint(x: 0, y: 0))
        
        squarePath.addLine(to: CGPoint(x: volumeView.bounds.width, y: 0))
        
        squarePath.addLine(to: CGPoint(x: volumeView.bounds.width, y: volumeView.bounds.height))
        
        squarePath.addLine(to: CGPoint(x: 0, y: volumeView.bounds.height))
        
        squarePath.close()
        
        //垂直線
        for i in 1...section {
            
            let x = 60 * i
            
            squarePath.move(to: CGPoint(x: x, y: 0))
            
            squarePath.addLine(to: CGPoint(x: CGFloat(x), y: volumeView.bounds.height))
            
        }
        
        //水平線
        for i in 1...2 {
            
            let y = Int(volumeView.bounds.height/3) * i
            
            squarePath.move(to: CGPoint(x: 0, y: y))
            
            squarePath.addLine(to: CGPoint(x: volumeView.bounds.width, y: CGFloat(y)))
            
            
        }
        
        squareLayer.path = squarePath.cgPath
        
        squareLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        
        squareLayer.lineWidth = 1
        
        squareLayer.backgroundColor = UIColor.clear.cgColor
        
        volumeView.layer.addSublayer(squareLayer)
        
    }
    
    func addVolumeLabel() {
        
        guard let maxV = arrayV.max() else { return }
        
        for i in 1...3 {
            
            let height = volumeLabelView.bounds.height/3
            
            let label = UILabel(frame: CGRect(x: 0,
                                               y: 0 + Int(height) * (i - 1) - 10,
                                               width: Int(volumeLabelView.bounds.width),
                                               height: 20))
            
            label.textColor = UIColor.white
            
            label.font = UIFont(name: ".SFUIText", size: 13)
            
            var v = (maxV/3) * (4 - i)
            
            if i == 1 {
                
                v = maxV
            }
            
            label.text = "\(v)"
            
            volumeLabelView.addSubview(label)
            
        }
        
    }
    
    func addTimeLabel() {
        
        guard let start = arrayT.first,
            let end = arrayT.last,
            let st = trend?.root.st else { return }
        
        guard let stTime = Int(st) else { return }
        
        var startTime = (stTime % 10000)/100
        
        let section = (end - start)/60
        
        let xRatio = Double(timeView.bounds.width)/Double(end - start + 1)
        
        for i in 0...section {
            
            let x = Int(xRatio * 60) * i
            
            let label = UILabel(frame: CGRect(x: 0 + x, y: 0, width: 40, height: 20))
            
            label.textColor = UIColor.white
            
            label.font = UIFont(name: ".SFUIText", size: 15)
            
            if startTime < 10 {
                
                label.text = "0\(startTime)"
                
            } else {
                
                label.text = "\(startTime)"
            }
            
            startTime += 1
            
            timeView.addSubview(label)
        }
        
    }
    
    func setupDate(from trendManager: TrendManager, trend: Trend) {
        
        arrayC = trendManager.insertAllC(from: trend)
        
        arrayT = trendManager.insertAllT(from: trend)
        
        arrayL = trendManager.insertAllL(from: trend)
        
        arrayH = trendManager.insertAllH(from: trend)
        
        arrayV = trendManager.insertAllV(from: trend)
        
        
    }

}

