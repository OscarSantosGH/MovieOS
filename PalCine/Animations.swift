//
//  Animations.swift
//  PalCine
//
//  Created by Oscar Santos on 10/20/18.
//  Copyright © 2018 Oscar Santos. All rights reserved.
//

import UIKit

class Animations {
    
    static let shareInstance = Animations()
    
    private init(){}
    
    func heartBeat(view: UIView){
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        }, completion: { (bool) in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.3, options: UIView.AnimationOptions.curveLinear, animations: {
                view.transform = CGAffineTransform.identity
            })
        })
    }
    
    func startLoading(views:[UIView]){
        for view in views{
            let animView = UIView(frame: view.frame)
            animView.tag = 1000
            animView.isOpaque = true
            view.insertSubview(animView, at: 5)
            animView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
            animView.layer.backgroundColor = UIColor.rgb(red: 145, green: 94, blue: 196, alpha: 1).cgColor
            UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse, .repeat], animations: {
                animView.layer.backgroundColor = UIColor.rgb(red: 83, green: 50, blue: 191, alpha: 1).cgColor
            })
        }
        
    }
    
    func stopLoading(views:[UIView]){
        for view in views{
            for v in view.subviews{
                if v.tag == 1000{
                    v.removeFromSuperview()
                }
            }
        }
    }
    
}
