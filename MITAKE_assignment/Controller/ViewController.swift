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
    
    @IBOutlet weak var priceView: UIView!
    
    @IBOutlet weak var volumeView: UIView!
    
    @IBOutlet weak var volumeLabelView: UIView!
    
    @IBOutlet weak var timeView: UIView!
    
    @IBOutlet weak var tpLabel: UILabel!
    
    @IBOutlet weak var cLabel: UILabel!
    
    @IBOutlet weak var bpLabel: UILabel!
    
    var trendManager = TrendManager(fileName: "trend_2201")
    
    var arrayC = [Double]()
    
    var arrayT = [Int]()
    
    var arrayH = [Double]()
    
    var arrayL = [Double]()
    
    var arrayV = [Int]()
    
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
        
        arrayT = trendManager.arrayT
        
        arrayL = trendManager.arrayL
        
        arrayH = trendManager.arrayH
        
        arrayV = trendManager.arrayV
        
        drawTrendSquare()
        
        drawVolumeSquare()

        drawTrend()
        
        addPriceLabel()

        addVolumeLabel()
        
        addTimeLabel()
        
        drawVolume()
        
    }
    
    func drawTrend() {
       
        //Layer
        let redLayer = CAShapeLayer()
        
        let yellowLayer = CAShapeLayer()
        
        let greenLayer = CAShapeLayer()
       
        //Path
        let redPath = UIBezierPath()
        
        let yellowPath = UIBezierPath()
        
        let greenPath = UIBezierPath()
        
        if let trend = trend {
            
            guard let tp = Double(trend.root.tp),
                let bp = Double(trend.root.bp) else { return }
            
            let hRatio = Double(trendView.bounds.height)/(
                tp - bp )
            
            guard let startTime = arrayT.first,
                let endTime = arrayT.last else { return }
            
            let wRatio = Double(trendView.bounds.width)/Double(endTime - startTime + 1)
            
            let center = Double(trend.root.c)
            
            let arrayY = arrayC.map{ ($0 - center!) * hRatio }
            
            let arrayX = arrayT.map{ ( Double($0) * wRatio) }
            
            if let (maxIndex, maxValue) = arrayH.enumerated().max(by: { $0.element < $1.element}) {
                
                var x = maxIndex * Int(wRatio)
                
                let y = (maxValue - center!) * hRatio
                
                if x - 20 < 0 {
                    
                    x = 0
                    
                } else if x + 20 > Int(trendView.bounds.width) {
                    
                    x -= 20
                    
                }
                
                let label = UILabel(frame: CGRect(x: x, y: Int(trendView.bounds.height/2) - Int(y) - 20 , width: 50, height: 20))
                
                label.font = UIFont(name: ".SFUIText", size: 13)
                
                label.text = String(maxValue)
                
                label.textColor = UIColor.white
                
                trendView.addSubview(label)
            }
            
            if let (minIndex, minValue) = arrayL.enumerated().min(by: { $0.element < $1.element}) {
                
                var x = minIndex * Int(wRatio)
                
                let y = (minValue - center!) * hRatio
                
                if x - 20 < 0 {
                    
                    x = 0
                }  else if x + 20 > Int(trendView.bounds.width) {
                    
                    x -= 20
                    
                }
                
                let label = UILabel(frame: CGRect(x: x, y: Int(trendView.bounds.height/2) + Int(y) + 20 , width: 50, height: 20))
                
                label.font = UIFont(name: ".SFUIText", size: 13)

                label.text = String(minValue)

                label.textColor = UIColor.white

                trendView.addSubview(label)
            }
            
            for i in 0..<arrayY.count {
                
                //MOVE Path in different situation
                if i == 0 {
                
                    if arrayY[i] > 0.0 {
                        
                        redPath.move(to: CGPoint(x: 0, y: Double(trendView.bounds.height/2)))
                        
                    } else if arrayY[i] == 0.0 {
                        
                        yellowPath.move(to: CGPoint(x: 0, y: Double(trendView.bounds.height/2)))
                        
                    } else {
                        
                        greenPath.move(to: CGPoint(x: 0, y: Double(trendView.bounds.height/2)))
                        
                    }
                
                } else if i != 0 && arrayY[i - 1] * arrayY[i] < 0.0 {
                   
                    if arrayY[i] > 0.0 {
                        
                        redPath.move(to: CGPoint(x: arrayX[i], y: Double(trendView.bounds.height/2)))
                        
                    } else {
                        
                        greenPath.move(to: CGPoint(x: arrayX[i], y: Double(trendView.bounds.height/2)))
                    }
                    
                } else if i != 0 && arrayY[i - 1] * arrayY[i] == 0.0 {
                    
                    if arrayY[i] == 0 && arrayY[i-1] != 0.0 {
                        
                        yellowPath.move(to: CGPoint(x: arrayX[i], y: Double(trendView.bounds.height/2)))
                        
                    } else if arrayY[i] > 0.0 {
                        
                        redPath.move(to: CGPoint(x: arrayX[i], y: Double(trendView.bounds.height/2)))
                        
                    } else {
                        
                        greenPath.move(to: CGPoint(x: arrayX[i], y: Double(trendView.bounds.height/2)))
                    }
                    
                }
                
                //Add line
                if arrayY[i] > 0.0 {
                    
                    redPath.addLine(to: CGPoint(x: arrayX[i], y: Double(trendView.bounds.height/2) - arrayY[i]))
                    
                    if i + 1 < arrayY.count && arrayY[i + 1] <= 0.0 {
                        
                        redPath.addLine(to: CGPoint(x: arrayX[i+1], y: Double(trendView.bounds.height/2)))
                        
                    } else if i == arrayY.count - 1 {
                        
                        redPath.addLine(to: CGPoint(x: arrayX[i], y: Double(trendView.bounds.height/2)))
                    }
                    
                } else if arrayY[i] == 0.0 {
                    
                    yellowPath.addLine(to: CGPoint(x: arrayX[i], y: Double(trendView.bounds.height/2)))
                    
                } else {
                    
                    greenPath.addLine(to: CGPoint(x: arrayX[i], y: Double(trendView.bounds.height/2) - arrayY[i]))
                    
                    if i + 1 < arrayY.count && arrayY[i + 1] >= 0.0 {
                        
                        greenPath.addLine(to: CGPoint(x: arrayX[i+1], y: Double(trendView.bounds.height/2)))
                        
                    } else if i == arrayY.count - 1 {
                        
                        greenPath.addLine(to: CGPoint(x: arrayX[i], y: Double(trendView.bounds.height/2)))
                    }
                    
                }
                
            }
            
            
        }
        
        //Set color for each path and layer
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

        //Add subLayer for trendView
        trendView.layer.addSublayer(redLayer)

        trendView.layer.addSublayer(yellowLayer)

        trendView.layer.addSublayer(greenLayer)

        
    }
    
    func drawTrendSquare() {
        
        guard let startTime = arrayT.first,
            let endTime = arrayT.last else { return }
        
        let section = (endTime - startTime + 1)/60
        
        let squarePath = UIBezierPath()
        
        let squareLayer = CAShapeLayer()
        
        //Draw border
        squarePath.move(to: CGPoint(x: 0, y: 0))
        
        squarePath.addLine(to: CGPoint(x: trendView.bounds.width, y: 0))
        
        squarePath.addLine(to: CGPoint(x: trendView.bounds.width, y: trendView.bounds.height))
        
        squarePath.addLine(to: CGPoint(x: 0, y: trendView.bounds.height))
        
        squarePath.close()
        
        //垂直線
        for i in 1...section {
            
            let x = 60 * i
            
            squarePath.move(to: CGPoint(x: x, y: 0))
            
            squarePath.addLine(to: CGPoint(x: CGFloat(x), y: trendView.bounds.height))
            
        }
        
        //水平線
        for i in 1...3 {
            
            let y = Int(trendView.bounds.height/4) * i
            
            squarePath.move(to: CGPoint(x: 0, y: y))
            
            squarePath.addLine(to: CGPoint(x: trendView.bounds.width, y: CGFloat(y)))
            
            
        }
        
        squareLayer.path = squarePath.cgPath
        
        squareLayer.strokeColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
        
        squareLayer.lineWidth = 1
        
        squareLayer.backgroundColor = UIColor.clear.cgColor
        
        trendView.layer.addSublayer(squareLayer)
        
    }
    
    func addPriceLabel() {
        
        let height = bpLabel.bounds.height
        
        let middle1 = UILabel(frame: CGRect(x: 0,
                                            y: priceView.bounds.height/4 - height/2,
                                            width: priceView.bounds.width,
                                            height: height))
        
        let middle2 = UILabel(frame: CGRect(x: 0,
                                            y: 3*priceView.bounds.height/4 - height/2,
                                            width: priceView.bounds.width,
                                            height: height))
        
        middle1.textColor = UIColor.red
        
        middle2.textColor = UIColor.green
        
        if let tp = trend?.root.tp,
            let c = trend?.root.c,
            let bp = trend?.root.bp {
            
            guard let tp = Double(tp),
                let c = Double(c),
                let bp = Double(bp) else { return }
            
            let price1 = round(100 * (tp + c) / 2) / 100
            
            let price2 = round(100 * (bp + c) / 2) / 100
            
            middle1.text = "\(price1)"
            
            middle2.text = "\(price2)"
         
        }
      
        priceView.addSubview(middle1)
        
        priceView.addSubview(middle2)
        
    }
    
    func drawVolume() {
        
        let volumePath = UIBezierPath()
        
        let layer = CAShapeLayer()
        
        guard let max = arrayV.max(),
            let startTime = arrayT.first,
            let endTime = arrayT.last else { return }
        
        let yRatio = volumeView.bounds.height/CGFloat(max)
        
        let xRatio = Double(trendView.bounds.width)/Double(endTime - startTime + 1)
        
        let arrayX = arrayT.map{ ( Double($0) * xRatio) }
        
        let arrayY = arrayV.map{ Double($0) * Double(yRatio)}
        
        for i in 0..<arrayY.count {
            
            volumePath.move(to: CGPoint(x: Int(arrayX[i]), y: Int(volumeView.bounds.height)))
            
            volumePath.addLine(to: CGPoint(x: Int(arrayX[i]), y: Int(volumeView.bounds.height) - Int(arrayY[i])))
            
        }
        
        layer.strokeColor = UIColor(red: 85/255, green: 162/255, blue: 214/255, alpha: 1).cgColor
        
        layer.lineWidth = 0.6
        
        layer.path = volumePath.cgPath
        
        volumeView.layer.addSublayer(layer)
        
    }
    
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

}

