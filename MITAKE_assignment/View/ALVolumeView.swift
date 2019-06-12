//
//  ALVolumeView.swift
//  MITAKE_assignment
//
//  Created by 蔡佳宣 on 2019/6/12.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class ALVolumeView: UIView {

    var wRatio: Double = 1
    
    var hRatio: Double = 1
    
    var maxVolume: Int = 1
    
    var timeStamp: Int = 0
    
    let volumeView = UIView()
    
    func showVolumeWith(st: Int, tick: [TickNum]) {
        
        addSubView()
        
        timeStamp = st
        
        if let startTime = tick.first?.t,
            let endTime = tick.last?.t,
            let maxTick = tick.max(by: { $0.v < $1.v }){
    
            drawBackground(startTime, endTime)
            
            drawVolumeWith(startTime, endTime, tick)
            
            addTimeLabel(startTime, endTime)
            
            maxVolume = maxTick.v
            
            addVolumeLabel()
        }
        
    }
    
    func addSubView() {
        
        volumeView.frame = CGRect(x: 50,
                                 y: 0,
                                 width: self.bounds.width-50,
                                 height: self.bounds.height)
        
        self.addSubview(volumeView)
        
    }
    
    private func drawVolumeWith(_ startTime: Int,
                                _ endTime: Int,
                                _ tick: [TickNum]) {
        
        let volumePath = UIBezierPath()
    
        let layer = CAShapeLayer()
        
        if let max = tick.max(by: { $0.v < $1.v }) {
            
            hRatio = Double(volumeView.bounds.height/CGFloat(max.v))
        }
        
        wRatio = Double(volumeView.bounds.width)/Double(endTime - startTime + 1)
    
        let arrayX = tick.map({ ( Double($0.t) * wRatio) })
        
        let arrayY = tick.map({ Double($0.v) * Double(hRatio)})
    
        for i in 0..<arrayY.count {
    
            volumePath.move(to: CGPoint(x: Int(arrayX[i]), y: Int(volumeView.bounds.height)))
    
            volumePath.addLine(to: CGPoint(x: Int(arrayX[i]), y: Int(volumeView.bounds.height) - Int(arrayY[i])))
    
        }
    
        layer.strokeColor = UIColor(red: 85/255, green: 162/255, blue: 214/255, alpha: 1).cgColor
    
        layer.lineWidth = 0.6
        
        layer.path = volumePath.cgPath
    
        volumeView.layer.addSublayer(layer)
    
    }
    
    private func drawBackground(_ startTime: Int, _ endTime: Int) {
        
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

        for i in 1...3 {

            let height = self.bounds.height/3

            let label = UILabel(frame: CGRect(x: 0,
                                              y: 0 + Int(height) * (i - 1) - 10,
                                              width: 30,
                                              height: 20))

            label.textColor = UIColor.white

            label.font = UIFont(name: ".SFUIText", size: 13)

            var v = (Int(maxVolume)/3) * (4 - i)

            if i == 1 {

                v = maxVolume
            }

            label.text = "\(v)"

            self.addSubview(label)

        }

    }

    func addTimeLabel(_ startTime: Int, _ endTime: Int) {
        
        var startTime = (timeStamp % 10000)/100

        let section = (endTime - startTime)/60

        let xRatio = Double(volumeView.bounds.width)/Double(endTime - startTime + 1)

        for i in 0...section {

            let x = Int(xRatio * 60) * i

            let label = UILabel(frame: CGRect(x: Int(volumeView.frame.origin.x) + x,
                                              y: Int(volumeView.frame.origin.y + volumeView.bounds.height + 5),
                                              width: 40,
                                              height: 20))

            label.textColor = UIColor.white

            label.font = UIFont(name: ".SFUIText", size: 15)

            if startTime < 10 {

                label.text = "0\(startTime)"

            } else {

                label.text = "\(startTime)"
            }

            startTime += 1

            self.addSubview(label)
        }

    }

}
