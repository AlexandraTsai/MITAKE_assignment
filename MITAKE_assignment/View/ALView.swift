//
//  ALView.swift
//  MITAKE_assignment
//
//  Created by 蔡佳宣 on 2019/6/15.
//  Copyright © 2019 蔡佳宣. All rights reserved.
//

import UIKit

class ALView: UIView {
    
    func addSubLayer(_ layer: CAShapeLayer,
                     path: CGPath,
                     lineWidth: CGFloat?,
                     strokeColor: CGColor?,
                     fillColor: CGColor?,
                     on superView: UIView) {
        
        layer.path = path
        
        if let strokeColor = strokeColor,
            let lineWidth = lineWidth,
            let fillColor = fillColor {
            
            layer.strokeColor = strokeColor
            
            layer.lineWidth = lineWidth
            
            layer.fillColor = fillColor
            
        }
        
        superView.layer.addSublayer(layer)
        
    }
    
    //Draw Background
    func drawBackground(_ startTime: Int,
                        _ endTime: Int,
                        hSection: Int,
                        on baseView: UIView) {
        
        let section = (endTime - startTime + 1)/60
        
        let squarePath = UIBezierPath()
        
        let squareLayer = CAShapeLayer()
        
        //Draw border
        squarePath.move(to: CGPoint(x: 0, y: 0))
        
        squarePath.addLine(to: CGPoint(x: baseView.bounds.width, y: 0))
        
        squarePath.addLine(to: CGPoint(x: baseView.bounds.width, y: baseView.bounds.height))
        
        squarePath.addLine(to: CGPoint(x: 0, y: baseView.bounds.height))
        
        squarePath.close()
        
        //垂直線
        for i in 1...section {
            
            let x = 60 * i
            
            squarePath.move(to: CGPoint(x: x, y: 0))
            
            squarePath.addLine(to: CGPoint(x: CGFloat(x), y: baseView.bounds.height))
            
        }
        
        //水平線
        for i in 1...hSection {
            
            let y = Int(baseView.bounds.height/3) * i
            
            squarePath.move(to: CGPoint(x: 0, y: y))
            
            squarePath.addLine(to: CGPoint(x: baseView.bounds.width, y: CGFloat(y)))
            
        }
        
        addSubLayer(squareLayer,
                    path: squarePath.cgPath,
                    lineWidth: 1,
                    strokeColor: UIColor.lightGray.withAlphaComponent(0.3).cgColor,
                    fillColor: UIColor.clear.cgColor,
                    on: baseView)
        
    }

}
