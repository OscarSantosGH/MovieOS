//
//  RootViewController.swift
//  PalCine
//
//  Created by Oscar Santos on 11/2/18.
//  Copyright © 2018 Oscar Santos. All rights reserved.
//

import UIKit

class RootViewController:UIViewController{
    
    private var _preferredStyle = UIStatusBarStyle.default;
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return _preferredStyle
        }
        set {
            _preferredStyle = newValue
            self.setNeedsStatusBarAppearanceUpdate()
        }
        
    }
    
    override func viewDidLoad() {
        modalPresentationCapturesStatusBarAppearance = true;
    }
    
    
    override func willMove(toParent parent: UIViewController?) {
        if let last = self.navigationController?.viewControllers.last as? RootViewController{
            if last == self && self.navigationController!.viewControllers.count > 1{
                if let parent = self.navigationController!.viewControllers[self.navigationController!.viewControllers.count - 2] as? RootViewController{
                    parent.setNavigationColors()
                }
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if let parent = navigationController?.viewControllers.last as? RootViewController{
            parent.animateNavigationColors()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.setNavigationColors()
    }
    
    func animateNavigationColors(){
        self.setBeforePopNavigationColors()
        transitionCoordinator?.animate(alongsideTransition: { [weak self](context) in
            self?.setNavigationColors()
            }, completion: nil)
    }
    
    func setBeforePopNavigationColors() {
        //Override in subclasses
    }
    
    func setNavigationColors(){
        //Override in subclasses
    }
    
}
