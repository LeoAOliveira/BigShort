//
//  SectorChartView.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 27/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit

@IBDesignable
class SectorChartView: UIView {
    
    @IBInspectable
    var firstValue:CGFloat = 0.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var circleWidth:CGFloat = 10.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var firstValueColor: UIColor = #colorLiteral(red: 0.488651216, green: 0.7119327188, blue: 1, alpha: 1)
    
    @IBInspectable
    var secondValueColor: UIColor = #colorLiteral(red: 0.8195264935, green: 0.8196648955, blue: 0.8195083141, alpha: 1)
    
    override func draw(_ rect: CGRect) {
        
        let fullCircle = CGFloat(2.0 * Double.pi)
        
        let start:CGFloat = -0.25 * fullCircle
        
        let firstValueEnd: CGFloat = firstValue * fullCircle + start
        
        let centerPoint = CGPoint(x: rect.midX, y: rect.midY)
        
        var radius:CGFloat = 0.0
        
        if rect.width < rect.height {
            radius = (rect.width - circleWidth) / 2.0
        } else {
            radius = (rect.height - circleWidth) / 2.0
        }
        
        let graphicsContext = UIGraphicsGetCurrentContext()
        
        graphicsContext?.setLineWidth(circleWidth)
        graphicsContext?.setLineCap(CGLineCap.square)
        
        graphicsContext?.setStrokeColor(self.secondValueColor.cgColor)
        graphicsContext?.addArc(center: centerPoint, radius: radius, startAngle: 0, endAngle: fullCircle, clockwise: false)
        graphicsContext?.strokePath()
        
        graphicsContext?.setStrokeColor(firstValueColor.cgColor)
        graphicsContext?.addArc(center: centerPoint, radius: radius, startAngle: start, endAngle: firstValueEnd, clockwise: false)
        graphicsContext?.strokePath()
    }
}
