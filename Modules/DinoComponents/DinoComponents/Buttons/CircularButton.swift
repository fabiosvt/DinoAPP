//
//  CircularButton.swift
//  DinoComponents
//
//  Created by Fabio Silvestri on 26/09/21.
//

import UIKit

@IBDesignable
class CircularButton: UIButton {

    @IBInspectable public var cornerRadius: CGFloat = 0
    @IBInspectable public var lineThickness: CGFloat = 0
    @IBInspectable public var lineColor: UIColor = .white
    @IBInspectable public var fillColor: UIColor = .clear
    @IBInspectable public var lineWidthPercentage: CGFloat = 0.6
    
    public override func draw(_ rect: CGRect) {

        layer.cornerRadius = cornerRadius
        layer.backgroundColor = fillColor.cgColor
        
        let lineWidth = min(bounds.width, bounds.height) * lineWidthPercentage
        let shapeLayer = CAShapeLayer()
        
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        
        shapeLayer.path = path.cgPath
        layer.addSublayer(shapeLayer)
        
        lineColor.setStroke()
        path.move(to: CGPoint(x: bounds.width/2 - lineWidth/2 + 0.5, y: bounds.height/2 + 0.5))
        path.addLine(to: CGPoint(x: bounds.width/2 + lineWidth/2, y: bounds.height/2 + 0.5))
        path.move(to: CGPoint(x: bounds.width/2 + 0.5, y: bounds.height/2 - lineWidth/2 + 0.5))
        path.addLine(to: CGPoint(x: bounds.width/2 + 0.5, y: bounds.height/2 + lineWidth/2 + 0.5))
        path.stroke()
    }

    
}
