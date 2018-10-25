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

extension UIImage{
    static func createBackdropPlaceholderImage() -> UIImage?{
        let color1 = UIColor.rgb(red: 156, green: 88, blue: 202, alpha: 1)
        let color2 = UIColor.rgb(red: 93, green: 24, blue: 142, alpha: 1)
        let gradient = CAGradientLayer(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000), colors: [color1, color2])
        return gradient.creatGradientImage()
    }
}

extension UIColor {
    static func rgb(red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}

extension UIView{
    func setGradientBG(colors: [UIColor]){
        let updatedFrame = bounds
        //updatedFrame.size.width = updatedFrame.size.width * 2
        let gradientLayer = CAGradientLayer(frame: updatedFrame, colors: colors)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading:NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        
        if let myTop = top{
            topAnchor.constraint(equalTo: myTop, constant: padding.top).isActive = true
        }
        if let myLeading = leading{
            leadingAnchor.constraint(equalTo: myLeading, constant: padding.left).isActive = true
        }
        if let myBottom = bottom{
            bottomAnchor.constraint(equalTo: myBottom, constant: -padding.bottom).isActive = true
        }
        if let myTrailing = trailing{
            trailingAnchor.constraint(equalTo: myTrailing, constant: -padding.right).isActive = true
        }

        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}

extension UIImageView{
    func insertPlayBtn(){
        DispatchQueue.main.async {
            let updatedFrame:CGRect = self.bounds
            let playBtn:PlayTrailerButton = PlayTrailerButton(frame: updatedFrame)
            self.insertSubview(playBtn, at: 1)
        }
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
}

enum moviesCategories {
    case Popular
    case Upcoming
    case NowPlaying
    case Featured
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
