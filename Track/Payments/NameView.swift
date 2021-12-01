//
//  NameView.swift
//  Track
//
//  Created by John Yeo on 13/6/20.
//  Copyright © 2020 Sine. All rights reserved.
//

import Foundation

import UIKit
@IBDesignable
class RadialGradientView: UIView {
    
    @IBInspectable var InsideColor: UIColor = UIColor.clear
    @IBInspectable var OutsideColor: UIColor = UIColor.clear
    
    override func draw(_ rect: CGRect) {
        let colors = [InsideColor.cgColor, OutsideColor.cgColor] as CFArray
        let endRadius = min(frame.width, frame.height)/2
        let center = CGPoint(x: bounds.size.width/2, y: bounds.size.height/2)
        
        let gradient = CGGradient(colorsSpace: nil, colors: colors, locations: nil)
        
        UIGraphicsGetCurrentContext()!.drawRadialGradient(gradient!, startCenter: CGPoint(x:0, y: 0), startRadius: 0.0, endCenter: CGPoint(x: 00, y: 40), endRadius: 400, options: CGGradientDrawingOptions.drawsAfterEndLocation)
        
    }
}
