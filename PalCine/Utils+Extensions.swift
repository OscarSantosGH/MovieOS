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
    
    func createGradientImage() -> UIImage? {
        
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
        
        setBackgroundImage(gradientLayer.createGradientImage(), for: UIBarMetrics.default)
    }
}

extension UIImage{
    static func createBackdropPlaceholderImage() -> UIImage?{
        let color1 = UIColor.rgb(red: 156, green: 88, blue: 202, alpha: 1)
        let color2 = UIColor.rgb(red: 93, green: 24, blue: 142, alpha: 1)
        let gradient = CAGradientLayer(frame: CGRect(x: 0, y: 0, width: 1000, height: 1000), colors: [color1, color2])
        return gradient.createGradientImage()
    }
}

extension UIColor {
    static func rgb(red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat) -> UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}

extension UIView{
    func setGradientBG(colors: [UIColor]){
        layoutIfNeeded()
        let updatedFrame = bounds
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
    
    func centerAnchors(centerEqualTo: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: centerEqualTo.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: centerEqualTo.centerYAnchor).isActive = true
    }
}

extension UIImageView{
    func insertPlayBtn(){
        DispatchQueue.main.async {
            for v in self.subviews{
                v.removeFromSuperview()
            }
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

extension UINavigationBar {
    func installBlurEffect() {
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .default)
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        var blurFrame = bounds
        blurFrame.size.height += statusBarHeight
        blurFrame.origin.y -= statusBarHeight
        let blurView  = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.isUserInteractionEnabled = false
        blurView.frame = blurFrame
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurView)
        blurView.layer.zPosition = -1
    }
    
    func hideBlurFX(){
        guard let barBG = subviews.first else {return}
        barBG.alpha = 0
    }
    
    func showBlurFX(){
        guard let barBG = subviews.first else {return}
        barBG.alpha = 1
    }
}

extension UITabBarController {
    func setTabBar(
        hidden: Bool,
        animated: Bool = true,
        along transitionCoordinator: UIViewControllerTransitionCoordinator? = nil
    ) {
        guard isTabBarHidden != hidden else { return }

        let offsetY = hidden ? tabBar.frame.height : -tabBar.frame.height
        let endFrame = tabBar.frame.offsetBy(dx: 0, dy: offsetY)
        let vc: UIViewController? = viewControllers?[selectedIndex]
        var newInsets: UIEdgeInsets? = vc?.additionalSafeAreaInsets
        let originalInsets = newInsets
        newInsets?.bottom -= offsetY

        func set(childViewController cvc: UIViewController?, additionalSafeArea: UIEdgeInsets) {
            cvc?.additionalSafeAreaInsets = additionalSafeArea
            cvc?.view.setNeedsLayout()
        }

        if hidden, let insets = newInsets { set(childViewController: vc, additionalSafeArea: insets) }

        guard animated else {
            tabBar.frame = endFrame
            return
        }

        weak var tabBarRef = self.tabBar
        if let tc = transitionCoordinator {
            tc.animateAlongsideTransition(in: self.view, animation: { _ in tabBarRef?.frame = endFrame }) { context in
                if !hidden, let insets = context.isCancelled ? originalInsets : newInsets {
                    set(childViewController: vc, additionalSafeArea: insets)
                }
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: { tabBarRef?.frame = endFrame }) { didFinish in
                if !hidden, didFinish, let insets = newInsets {
                    set(childViewController: vc, additionalSafeArea: insets)
                }
            }
        }
    }

    var isTabBarHidden: Bool {
        return !tabBar.frame.intersects(view.frame)
    }

}

extension UIViewController{
    func showAlert(title:String, message:String){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertView.dismiss(animated: true, completion: nil)
        }
        alertView.addAction(okAction)
        self.present(alertView, animated: true)
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
