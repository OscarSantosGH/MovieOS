//
//  NetNotificationView.swift
//  PalCine
//
//  Created by Oscar Santos on 10/23/18.
//  Copyright © 2018 Oscar Santos. All rights reserved.
//

import UIKit

class NetNotificationView {
    
    var connectionNotificationLBL:UILabel
    private weak var anim:Animations?
    var heightAnchor: NSLayoutConstraint?
    static let sharedInstance = NetNotificationView()
    
    private init(){
        connectionNotificationLBL = UILabel()
        anim = Animations.shareInstance
        heightAnchor = connectionNotificationLBL.heightAnchor.constraint(equalToConstant: 0)
        heightAnchor?.isActive = true
    }
    
    func presentNetNotificationView(onView:UIView) {
        connectionNotificationLBL.tag = 999
        onView.addSubview(connectionNotificationLBL)
        onView.bringSubviewToFront(connectionNotificationLBL)
        connectionNotificationLBL.text = NSLocalizedString("Internet connection lost", comment: "Internet connection lost message")
        connectionNotificationLBL.backgroundColor = UIColor.rgb(red: 211, green: 47, blue: 39, alpha: 1)
        connectionNotificationLBL.textColor = UIColor.white
        connectionNotificationLBL.textAlignment = .center
        connectionNotificationLBL.font = UIFont(name: "System", size: 12)
        
        
        connectionNotificationLBL.anchor(top: nil, leading: onView.leadingAnchor, bottom: onView.safeAreaLayoutGuide.bottomAnchor, trailing: onView.trailingAnchor)
        
        DispatchQueue.main.async { [unowned self] in
            self.showUpAnim(onView: onView)
        }
        
    }
    
    private func showUpAnim(onView:UIView){
        self.heightAnchor?.constant = 30
        UIView.animate(withDuration: 1, delay: 0.3, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            onView.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func dismissAnim(onView:UIView){
        self.heightAnchor?.constant = 0
        
        UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            onView.layoutIfNeeded()
        }) { (Bool) in
            for view in onView.subviews{
                if view.tag == 999{
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    func dismissNetNotificationView(onView:UIView){
        connectionNotificationLBL.text = NSLocalizedString("Back Online", comment: "Back Online message")
        connectionNotificationLBL.backgroundColor = UIColor.rgb(red: 114, green: 193, blue: 65, alpha: 1)
        
        DispatchQueue.main.async { [unowned self] in
            self.dismissAnim(onView: onView)
        }
    }
}
