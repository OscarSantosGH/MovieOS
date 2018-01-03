//
//  MovieDetailCurveShape.swift
//  PalCine
//
//  Created by Oscar Santos on 1/3/18.
//  Copyright © 2018 Oscar Santos. All rights reserved.
//

import UIKit

class MovieDetailCurveShape: UIView {

    let curveLayer = CAShapeLayer()
    let bezierPath = UIBezierPath()
    var oldPath:CGPath?
    var myRect = CGRect()
    
    private func createShapeLayer(){
        bezierPath.move(to: CGPoint(x: myRect.minX, y: myRect.maxY))
        bezierPath.addLine(to: CGPoint(x: myRect.maxX, y: myRect.maxY))
        bezierPath.addLine(to: CGPoint(x: myRect.maxX, y: myRect.minY))
        bezierPath.addCurve(to: CGPoint(x: myRect.minX + 0.5 * myRect.width, y: myRect.minY + 0.8 * myRect.height), controlPoint1: CGPoint(x: myRect.maxX, y: myRect.minY), controlPoint2: CGPoint(x: myRect.minX + 0.76 * myRect.width, y: myRect.minY + 0.8 * myRect.height))
        bezierPath.addCurve(to: CGPoint(x: myRect.minX, y: myRect.minY), controlPoint1: CGPoint(x: myRect.minX + 0.2 * myRect.width, y: myRect.minY + 0.8 * myRect.height), controlPoint2: CGPoint(x: myRect.minX, y: myRect.minY))
        bezierPath.addLine(to: CGPoint(x: myRect.minX, y: myRect.maxY))
        bezierPath.close()
        
        curveLayer.path = bezierPath.cgPath
        curveLayer.fillColor = UIColor.white.cgColor
        
        oldPath = curveLayer.path
        self.layer.addSublayer(curveLayer)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        myRect = bounds
        createShapeLayer()
    }
    
    func animateShape(value:CGFloat){
        let positiveVal = value < 0 ? 0 : value
        let offsetPos = positiveVal > 75 ? 1 : positiveVal / 75
        let reverse = (offsetPos - 1) * -1
        let progress = reverse * 0.8
        let bezierPath2 = UIBezierPath()
        bezierPath2.move(to: CGPoint(x: myRect.minX, y: myRect.maxY))
        bezierPath2.addLine(to: CGPoint(x: myRect.maxX, y: myRect.maxY))
        bezierPath2.addLine(to: CGPoint(x: myRect.maxX, y: myRect.minY))
        bezierPath2.addCurve(to: CGPoint(x: myRect.minX + 0.5 * myRect.width, y: myRect.minY + progress * myRect.height), controlPoint1: CGPoint(x: myRect.maxX, y: myRect.minY), controlPoint2: CGPoint(x: myRect.minX + 0.76 * myRect.width, y: myRect.minY + progress * myRect.height))
        bezierPath2.addCurve(to: CGPoint(x: myRect.minX, y: myRect.minY), controlPoint1: CGPoint(x: myRect.minX + 0.2 * myRect.width, y: myRect.minY + progress * myRect.height), controlPoint2: CGPoint(x: myRect.minX, y: myRect.minY))
        bezierPath2.addLine(to: CGPoint(x: myRect.minX, y: myRect.maxY))
        bezierPath2.close()
        
        let basicAnim = CABasicAnimation(keyPath: "path")
        basicAnim.isRemovedOnCompletion = false
        basicAnim.fillMode = kCAFillModeForwards
        basicAnim.duration = 0.2
        basicAnim.fromValue = oldPath
        basicAnim.toValue = bezierPath2.cgPath
        
        oldPath = bezierPath2.cgPath
        curveLayer.add(basicAnim, forKey: "myPath")
    }


}
