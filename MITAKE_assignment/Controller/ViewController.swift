//
//  ViewController.swift
//  MITAKE_assignment
//
//  Created by 蔡佳宣 on 2019/6/10.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var trendView: UIView!
    
    @IBOutlet weak var tpLabel: UILabel!
    
    @IBOutlet weak var cLabel: UILabel!
    
    @IBOutlet weak var bpLabel: UILabel!
    
    var trendManager = TrendManager(fileName: "trend_2201")
    
    var arrayC = [Double]()
    
    var trend: Trend? {
        
        didSet {
            
            if let trend = trend {
                
                tpLabel.text = trend.root.tp
                
                cLabel.text = trend.root.c
                
                bpLabel.text = trend.root.bp
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        trendManager.readJsonFromFile()
        
        trend = trendManager.trend
        
        arrayC = trendManager.arrayC
        
        drawSquare()

        drawTrend()
        
    }
    
    func drawTrend() {
       
        let redLayer = CAShapeLayer()
        
        let yellowLayer = CAShapeLayer()
        
        let greenLayer = CAShapeLayer()
        
        let trendPath = UIBezierPath()
        
        let redPath = UIBezierPath()
        
        let yellowPath = UIBezierPath()
        
        let greenPath = UIBezierPath()
        
        if let trend = trend {
            
            guard let tp = Double(trend.root.tp),
                let bp = Double(trend.root.bp) else { return }
            
            let ratio = Double(view.bounds.height)/(
                tp - bp )
            
            let center = Double(trend.root.c)
            
            let array = arrayC.map{ ($0 - center!) * ratio }
            
            trendPath.move(to: CGPoint(x: 0, y: Double(trendView.bounds.height/2)))
            
            for i in 0..<array.count {
                
                //MOVE Path
                if i == 0 {
                
                    if array[i] > 0.0 {
                        
                        redPath.move(to: CGPoint(x: 0, y: Double(trendView.bounds.height/2)))
                        
                    } else if array[i] == 0.0 {
                        
                        yellowPath.move(to: CGPoint(x: 0, y: Double(trendView.bounds.height/2)))
                        
                    } else {
                        
                        greenPath.move(to: CGPoint(x: 0, y: Double(trendView.bounds.height/2)))
                        
                    }
                  
                //MOVE Path again
                } else if i != 0 && array[i - 1] * array[i] < 0.0 {
                   
                    if array[i] > 0.0 {
                        
                        redPath.move(to: CGPoint(x: Double(i), y: Double(trendView.bounds.height/2)))
                        
                    } else {
                        
                        greenPath.move(to: CGPoint(x: Double(i), y: Double(trendView.bounds.height/2)))
                    }
                    
                } else if i != 0 && array[i - 1] * array[i] == 0.0 {
                    
                    if array[i] == 0 && array[i-1] != 0.0 {
                        
                        yellowPath.move(to: CGPoint(x: Double(i), y: Double(trendView.bounds.height/2)))
                        
                    } else if array[i] > 0.0 {
                        
                        redPath.move(to: CGPoint(x: Double(i), y: Double(trendView.bounds.height/2)))
                        
                    } else {
                        
                        greenPath.move(to: CGPoint(x: Double(i), y: Double(trendView.bounds.height/2)))
                    }
                    
                }
                
                //Add line
                if array[i] > 0.0 {
                    
                    redPath.addLine(to: CGPoint(x: Double(i), y: Double(trendView.bounds.height/2) - array[i]))
                    
                    if i + 1 < array.count && array[i + 1] <= 0.0 {
                        
                        redPath.addLine(to: CGPoint(x: Double(i+1), y: Double(trendView.bounds.height/2)))
                    }
                    
                } else if array[i] == 0.0 {
                    
                    yellowPath.addLine(to: CGPoint(x: Double(i), y: Double(trendView.bounds.height/2)))
                    
                } else {
                    
                    greenPath.addLine(to: CGPoint(x: Double(i), y: Double(trendView.bounds.height/2) - array[i]))
                    
                    if i + 1 < array.count && array[i + 1] >= 0.0 {
                        
                        greenPath.addLine(to: CGPoint(x: Double(i+1), y: Double(trendView.bounds.height/2)))
                    }
                    
                }
                
            }
            
            
        }
        
        redLayer.path = redPath.cgPath
        
        redLayer.strokeColor = UIColor.red.cgColor
        
        redLayer.lineWidth = 1
        
        redLayer.fillColor = UIColor.red.withAlphaComponent(0.3).cgColor
        
        yellowLayer.path = yellowPath.cgPath
        
        yellowLayer.strokeColor = UIColor.yellow.cgColor
        
        yellowLayer.lineWidth = 1
        
        yellowLayer.fillColor = UIColor.clear.cgColor
        
        greenLayer.path = greenPath.cgPath

        greenLayer.strokeColor = UIColor.green.cgColor
        
        greenLayer.lineWidth = 1
        
        greenLayer.fillColor = UIColor.clear.cgColor
        
        greenLayer.fillColor = UIColor.green.withAlphaComponent(0.3).cgColor

        trendView.layer.addSublayer(redLayer)

        trendView.layer.addSublayer(yellowLayer)

        trendView.layer.addSublayer(greenLayer)

        
    }
    
    func drawSquare() {
        
        let squarePath = UIBezierPath()
        
        let squareLayer = CAShapeLayer()
        
        squarePath.move(to: CGPoint(x: 0, y: 0))
        
        squarePath.addLine(to: CGPoint(x: trendView.bounds.width, y: 0))
        
        squarePath.addLine(to: CGPoint(x: trendView.bounds.width, y: trendView.bounds.height))
        
        squarePath.addLine(to: CGPoint(x: 0, y: trendView.bounds.height))
        
        squarePath.close()
        
        // 垂直線
        squarePath.move(to: CGPoint(x: 60, y: 0))

        squarePath.addLine(to: CGPoint(x: 60, y: trendView.bounds.height))
        
        squarePath.move(to: CGPoint(x: 120, y: 0))
        
        squarePath.addLine(to: CGPoint(x: 120, y: trendView.bounds.height))
        
        squarePath.move(to: CGPoint(x: 180, y: 0))
        
        squarePath.addLine(to: CGPoint(x: 180, y: trendView.bounds.height))

        squarePath.move(to: CGPoint(x: 240, y: 0))
        
        squarePath.addLine(to: CGPoint(x: 240, y: trendView.bounds.height))
        
        // 水平線
        squarePath.move(to: CGPoint(x: 0, y: 300/4))
        
        squarePath.addLine(to: CGPoint(x: trendView.bounds.width, y: 300/4))
        
        squarePath.move(to: CGPoint(x: 0, y: (300/4) * 2))
        
        squarePath.addLine(to: CGPoint(x: trendView.bounds.width, y: (300/4) * 2))
        
        squarePath.move(to: CGPoint(x: 0, y: (300/4) * 3))
        
        squarePath.addLine(to: CGPoint(x: trendView.bounds.width, y: (300/4) * 3))
        
        squareLayer.path = squarePath.cgPath
        
        squareLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        
        squareLayer.lineWidth = 1
        
        squareLayer.backgroundColor = UIColor.clear.cgColor
        
        trendView.layer.addSublayer(squareLayer)
        
    }
    
}

