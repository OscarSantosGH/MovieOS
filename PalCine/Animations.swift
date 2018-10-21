//
//  Animations.swift
//  PalCine
//
//  Created by Oscar Santos on 10/20/18.
//  Copyright © 2018 Oscar Santos. All rights reserved.
//

import UIKit

class Animations {
    
    static func startLoading(views:[UIView]){
        
        for view in views{
            let animView = UIView(frame: view.frame)
            animView.tag = 1000
            view.insertSubview(animView, at: 5)
            animView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
            
            func anim(){
                animView.layer.backgroundColor = UIColor.white.cgColor
                UIView.animate(withDuration: 1, animations: {
                    animView.layer.backgroundColor = UIColor.purple.cgColor
                }) { (Bool) in
                    UIView.animate(withDuration: 1, animations: {
                        animView.layer.backgroundColor = UIColor.white.cgColor
                    }, completion: { (Bool) in
                        anim()
                    })
                }
            }
            anim()
        }
        
    }
    
    static func stopLoading(views:[UIView]){
        for view in views{
            for v in view.subviews{
                if v.tag == 1000{
                    v.removeFromSuperview()
                }
            }
        }
    }
    
}
