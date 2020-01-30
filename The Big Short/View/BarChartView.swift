//
//  BarChartView.swift
//  The Big Short
//
//  Created by Leonardo Oliveira on 27/01/20.
//  Copyright © 2020 Leonardo Oliveira. All rights reserved.
//

import UIKit

@IBDesignable
class BarChartView: UIView {
    
    @IBInspectable
    var lineWidth:CGFloat = 10.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var valueWidth:CGFloat = 0.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var lineColor:UIColor = UIColor.black
    
    @IBInspectable
    var valueColor:UIColor = UIColor.yellow
    
    
    override func draw(_ rect: CGRect) {
        
        let start:CGPoint   = CGPoint(x: rect.minX + lineWidth, y: rect.midY)
        let end:CGPoint     = CGPoint(x: rect.maxX - lineWidth, y: rect.midY)
        
        let space:CGFloat = end.x - start.x
        let endProgress = CGPoint(x: start.x + space * valueWidth, y: end.y)
        
        let graphicsContext = UIGraphicsGetCurrentContext()
        
        graphicsContext?.setLineWidth(lineWidth)
        graphicsContext?.setLineCap(CGLineCap.round)
        
        graphicsContext?.setStrokeColor(lineColor.cgColor)
        graphicsContext?.move(to: CGPoint(x: start.x, y: start.y))
        graphicsContext?.addLine(to: CGPoint(x: end.x, y: end.y))
        graphicsContext?.strokePath()
        
        graphicsContext?.setStrokeColor(valueColor.cgColor)
        graphicsContext?.move(to: CGPoint(x: start.x, y: start.y))
        graphicsContext?.addLine(to: CGPoint(x: endProgress.x, y: endProgress.y))
        graphicsContext?.strokePath()
    }
}
