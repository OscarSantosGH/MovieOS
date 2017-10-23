//
//  RampPaintView.swift
//  PalCine
//
//  Created by Oscar Santos on 9/22/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

@IBDesignable
class RampPaintView: UIView {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    @IBInspectable var color:UIColor = UIColor.clear
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        StyleKitRamp.drawCanvas1(frame: rect, color: color)
    }
    
   

}

