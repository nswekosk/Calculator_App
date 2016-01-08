//
//  GraphView.swift
//  Calculator
//
//  Created by Nicholas Swekosky on 3/22/15.
//  Copyright (c) 2015 SwekoDev. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    
    @IBInspectable
    var theBounds: CGRect = CGRect(x: CGFloat(90), y: CGFloat(40), width: CGFloat(320), height: CGFloat(320)) { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var pointsPerUnit: CGFloat = CGFloat(5) { didSet { setNeedsDisplay() } }
    
    var color = UIColor.blueColor()
    
    var graphCenter: CGPoint
    {
        return convertPoint(center, fromView: superview)
    }

    
    
    override func drawRect(rect: CGRect)
    {
        var axesDrawer = AxesDrawer(color: color)
        
        axesDrawer.drawAxesInRect(theBounds, origin: graphCenter, pointsPerUnit: pointsPerUnit)
    }
    

}
