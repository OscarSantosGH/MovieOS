//
//  MovieNavigationVC.swift
//  MovieOS
//
//  Created by Oscar Santos on 11/5/19.
//  Copyright © 2019 Oscar Santos. All rights reserved.
//

import UIKit

protocol NavigationBarReporting{
    var showNavBarBG: Bool { get }
    var navTintColor: UIColor { get }
}

final class MovieNavigationVC: UINavigationController {
    
    private var blurView: UIView = UIView()
    private var navBar = UINavigationBar()
    private var isConsecutiveAnimatedTransition = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        navBar = navigationBar
        
        // Get navigationBar frame height
        let statusBarHeight: CGFloat = UIApplication.shared.statusBarFrame.height
        var blurFrame = navigationBar.bounds
        blurFrame.size.height += statusBarHeight
        blurFrame.origin.y -= statusBarHeight
        
        // Clear the navigationBar
        navigationBar.backgroundColor = .clear
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navBar.isTranslucent = true
        
        if #available(iOS 13.0, *) {
            let blurFXView  = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
            blurFXView.isUserInteractionEnabled = false
            blurFXView.frame = blurFrame
            blurFXView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurView = blurFXView
            let navAppearance = UINavigationBarAppearance()
            navAppearance.configureWithTransparentBackground()

            navigationBar.standardAppearance = navAppearance
            navigationBar.addSubview(blurView)
            blurFXView.layer.zPosition = -1
        } else {
            // Fallback on earlier versions
            let blurFXView  = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
            blurFXView.isUserInteractionEnabled = false
            blurFXView.frame = blurFrame
            blurFXView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurView = blurFXView
            navigationBar.addSubview(blurView)
            blurFXView.layer.zPosition = -1
        }

    }
    
    private func setNavBarBG(_ navBarReporting: NavigationBarReporting){
        if navBarReporting.showNavBarBG{
            blurView.alpha = 1
        }else{
            blurView.alpha = 0
        }
    }

}

extension MovieNavigationVC: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

        guard let vc = (viewController as? NavigationBarReporting) else {return}

        let actions = { [blurView] in
            if vc.showNavBarBG{
                blurView.alpha = 1
            }else{
                blurView.alpha = 0
            }
        }

        guard animated else {
            return actions()
        }

        guard isConsecutiveAnimatedTransition else {
            UIView.animate(withDuration: transitionCoordinator?.transitionDuration ?? 0.0, animations: actions)
            isConsecutiveAnimatedTransition = true
            return
        }
        
        transitionCoordinator?.animate(alongsideTransition: { _ in
            actions()
        }, completion: { [weak self] context in
            
            guard context.isCancelled else { return }
            if let prevVC = (self?.topViewController as? NavigationBarReporting) {
                UIView.animate(withDuration: context.transitionDuration) {
                    self?.setNavBarBG(prevVC)
                    //self?.navigationBar.tintColor = prevVC.navTintColor
                    self?.navBar.tintColor = prevVC.navTintColor
                }
            }
        })
    }
}
