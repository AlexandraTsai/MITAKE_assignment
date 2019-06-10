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
       
        let layer = CAShapeLayer()
        
        let trendPath = UIBezierPath()
        
        if let trend = trend {
            
            guard let tp = Double(trend.root.tp),
                let bp = Double(trend.root.bp) else { return }
            
            let ratio = Double(view.bounds.height)/(
                tp - bp )
            
            let center = Double(trend.root.c)
            
            let array = arrayC.map{ ($0 - center!) * ratio }
            
            trendPath.move(to: CGPoint(x: 0, y: Double(trendView.bounds.height/2)))
            
            for i in 0..<array.count {
            
                trendPath.addLine(to: CGPoint(x: Double(trend.root.tick[i].t)! , y: Double(trendView.bounds.height/2) - array[i]))
                
            }
            
            trendPath.addLine(to: CGPoint(x: 270, y: Double(trendView.bounds.height/2)))
            
        }
        
        layer.path = trendPath.cgPath
        
//        UIColor.blue.setStroke()
//
//        trendPath.lineWidth = 5
//
//        trendPath.stroke()
//
//        layer.fillColor = UIColor.red.cgColor
        
        layer.strokeColor = UIColor.red.cgColor
        
        layer.lineWidth = 1
        
        layer.fillColor = UIColor.clear.cgColor
        
        trendView.layer.addSublayer(layer)

        
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

