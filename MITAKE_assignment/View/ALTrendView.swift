//
//  ALTrendView.swift
//  MITAKE_assignment
//
//  Created by 蔡佳宣 on 2019/6/12.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class ALTrendView: ALView {
    
    var wRatio: Double = 1
    
    var hRatio: Double = 1
    
    var centerV: Double = 1
    
    var tPrice: Double = 1
    
    var bPrice: Double = 1

    let trendView = UIView()
    
    func showTrendWith(startTime: String,
                       endTime: String,
                       tp: String,
                       bp: String,
                       c: String,
                       tick: [TickNum]) {
        
        guard let startTime = Int(startTime),
            let endTime = Int(endTime),
            let topPrice = Double(tp),
            let btmPrice = Double(bp),
            let center = Double(c) else { return }
        
        addSubView()
        
        centerV = center
        
        tPrice = topPrice
        
        bPrice = btmPrice
        
        setupRatio(topPrice, btmPrice, startTime, endTime)

        drawBackground(startTime, endTime, hSection: 3, on: trendView)
        
        drawTrendWith(startTime,
                      endTime,
                      topPrice,
                      btmPrice,
                      tick)
        
        setupLabel(with: tick)
        
        addPriceLabelWith(tp, bp, c)
        
    }
    
    func addSubView() {
        
        trendView.frame = CGRect(x: 50,
                                 y: 0,
                                 width: self.bounds.width-50,
                                 height: self.bounds.height)
        
        self.addSubview(trendView)
        
    }
    
    func setupRatio(_ topPrice: Double,
                  _ btmPrice: Double,
                  _ startTime: Int,
                  _ endTime: Int) {
        
        //Ratio
        hRatio = Double(trendView.bounds.height)/(
            topPrice - btmPrice )
        
        wRatio = Double(trendView.bounds.width)/Double(endTime - startTime + 1)
        
    }
    
    func drawTrendWith(_ startTime: Int,
                       _ endTime: Int,
                       _ topPrice: Double,
                       _ btmPrice: Double,
                       _ tick: [TickNum]) {
        
        //Layer
        let redLayer = CAShapeLayer()
        
        let yellowLayer = CAShapeLayer()
        
        let greenLayer = CAShapeLayer()
        
        //Path
        let redPath = UIBezierPath()
        
        let yellowPath = UIBezierPath()
        
        let greenPath = UIBezierPath()
        
        let arrayY = tick.map{ ($0.c - centerV) * hRatio }
            
        let arrayX = tick.map{ ( Double($0.t) * wRatio) }
        
        //Draw Trend
        for i in 0..<arrayY.count {
                
            //MOVE Path in different situation
            if i == 0 {
                    
                if arrayY[i] > 0.0 {
                        
                    movePathToCenter(redPath, with: 0)
                        
                } else if arrayY[i] == 0.0 {
                        
                    movePathToCenter(yellowPath, with: 0)

                        
                } else {
                        
                   movePathToCenter(greenPath, with: 0)
                }
                    
            } else if i != 0 && arrayY[i - 1] * arrayY[i] < 0.0 {
                    
                if arrayY[i] > 0.0 {
                        
                    movePathToCenter(redPath, with: arrayX[i])

                        
                } else {
                    
                    movePathToCenter(greenPath, with: arrayX[i])

                }
                    
            } else if i != 0 && arrayY[i - 1] * arrayY[i] == 0.0 {
                    
                if arrayY[i] == 0 && arrayY[i-1] != 0.0 {
                    
                    movePathToCenter(yellowPath, with: arrayX[i])
                        
                } else if arrayY[i] > 0.0 {
                    
                    movePathToCenter(redPath, with: arrayX[i-1])
                        
                } else if arrayY[i] < 0.0 {
                    
                    movePathToCenter(greenPath, with: arrayX[i-1])

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
        
        //Set color for each path and layer
        addSubLayer(redLayer,
              path: redPath.cgPath,
              lineWidth: 1,
              strokeColor: UIColor.red.cgColor,
              fillColor: UIColor.red.withAlphaComponent(0.3).cgColor,
              on: trendView)
        
        addSubLayer(yellowLayer,
              path: yellowPath.cgPath,
              lineWidth: 1,
              strokeColor: UIColor.yellow.cgColor,
              fillColor: UIColor.yellow.withAlphaComponent(0.3).cgColor,
              on: trendView)
        
        addSubLayer(greenLayer,
              path: greenPath.cgPath,
              lineWidth: 1,
              strokeColor: UIColor.green.cgColor,
              fillColor: UIColor.green.withAlphaComponent(0.3).cgColor,
              on: trendView)

    }
    
    func setupLabel(with tick: [TickNum]) {
        
        if let max = tick.max(by: { $0.h < $1.h }) {
            
            var x = Int(Double(max.t) * wRatio)
            
            let y = (max.h - centerV) * hRatio
            
            if x - 20 < 0 {
                
                x = 0
            
            } else if x + 20 > Int(trendView.bounds.width) {
            
                x -= 20
            
            }
            
            let label = UILabel(frame: CGRect(x: x, y: Int(trendView.bounds.height/2) - Int(y) - 20 , width: 50, height: 20))
            
            label.font = UIFont(name: ".SFUIText", size: 13)
            
            label.text = String(max.h)
            
            label.textColor = UIColor.white
            
            trendView.addSubview(label)
        }

        if let min = tick.min(by: { $0.l < $1.l}) {
           
            var x = Int(Double(min.t) * wRatio)

            let y = (min.l - centerV) * hRatio

            if x - 20 < 0 {

                x = 0
            
            }  else if x + 20 > Int(trendView.bounds.width) {

                x -= 20

            }

            let label = UILabel(frame: CGRect(x: x, y: Int(trendView.bounds.height/2) + Int(y) + 20 , width: 50, height: 20))

            label.font = UIFont(name: ".SFUIText", size: 13)

            label.text = String(min.l)

            label.textColor = UIColor.white

            trendView.addSubview(label)
        }

    }
    
    func addPriceLabelWith(_ topPrice: String,
                           _ btmPrice: String,
                           _ cPrice: String) {
        
        let height = 20
        
        let y = self.bounds.height/4
        
        for i in 0...4 {
            
            let label = UILabel()
            
            switch i {
            case 0:
                
                label.frame = CGRect(x: 0,
                                     y: Int(y) * i,
                                     width: 45,
                                     height: height)
                label.textColor = UIColor.white
                label.backgroundColor = UIColor.red
                label.text = topPrice
                
            case 1:
                
                label.frame = CGRect(x: 0,
                                     y: Int(y) * i - height/2,
                                     width: 45,
                                     height: height)
                label.textColor = UIColor.red
                label.text = "\(round(100 * (tPrice + centerV) / 2) / 100)"
                
            case 2:
                
                label.frame = CGRect(x: 0,
                                     y: Int(y) * i - height/2,
                                     width: 45,
                                     height: height)
                label.textColor = UIColor.white
                label.text = cPrice
                
            case 3:
                
                label.frame = CGRect(x: 0,
                                     y: Int(y) * i - height/2,
                                     width: 45,
                                     height: height)
                label.textColor = UIColor.green
                label.text = "\(round(100 * (bPrice + centerV) / 2) / 100)"
                
            case 4:
                
                label.frame = CGRect(x: 0,
                                     y: Int(y) * i - height,
                                     width: 45,
                                     height: height)
                label.textColor = UIColor.white
                label.backgroundColor = UIColor.green
                label.text = btmPrice

            default: break
                
            }
           
            self.addSubview(label)
            
        }

    }
    
    func movePathToCenter(_ path: UIBezierPath,with x: Double) {
        
        path.move(to: CGPoint(x: x, y: Double(trendView.bounds.height/2)))
    }
}
