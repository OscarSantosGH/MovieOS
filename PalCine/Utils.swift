//
//  Utils.swift
//  PalCine
//
//  Created by Oscar Santos on 6/26/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    convenience init(frame: CGRect, colors: [UIColor]) {
        self.init()
        self.frame = frame
        self.colors = []
        for color in colors {
            self.colors?.append(color.cgColor)
        }
        startPoint = CGPoint(x: 0, y: 0.1)
        endPoint = CGPoint(x: 0, y: 1)
    }
    
    func creatGradientImage() -> UIImage? {
        
        var image: UIImage? = nil
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return image
    }
    
}

extension UINavigationBar {
    
    func setGradientBackground(colors: [UIColor]) {
        
        var updatedFrame = bounds
        updatedFrame.size.height += 20
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        
        setBackgroundImage(gradientLayer.creatGradientImage(), for: UIBarMetrics.default)
    }
}

extension UIColor {
    static func rgb(red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}

extension UIView{
    func setGradientBG(colors: [UIColor]){
        let gradientLayer = CAGradientLayer(frame: self.bounds, colors: colors)
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

public let genresDic:Dictionary<Int,String> = [28:"Action",
                                               12:"Adventure",
                                               16:"Animation",
                                               35:"Comedy",
                                               80:"Crime",
                                               99:"Documentary",
                                               18:"Drama",
                                               10751:"Family",
                                               14:"Fantasy",
                                               36:"History",
                                               27:"Horror",
                                               10402:"Music",
                                               9648:"Mystery",
                                               10749:"Romance",
                                               878:"Science Fiction",
                                               10770:"TV Movie",
                                               53:"Thriller",
                                               10752:"War",
                                               37:"Western"]
