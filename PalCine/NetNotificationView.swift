//
//  NetNotificationView.swift
//  PalCine
//
//  Created by Oscar Santos on 10/23/18.
//  Copyright © 2018 Oscar Santos. All rights reserved.
//

import UIKit

class NetNotificationView {
    
    var isPresented:Bool
    var connectionNotificationLBL:UILabel
    static let sharedInstance = NetNotificationView()
    
    private init(){
        isPresented = false
        connectionNotificationLBL = UILabel()
    }
    
    func presentNetNotificationView(onView:UIView) {
        connectionNotificationLBL.tag = 999
        onView.addSubview(connectionNotificationLBL)
        connectionNotificationLBL.text = "Internet connection lost"
        connectionNotificationLBL.backgroundColor = UIColor.rgb(red: 211, green: 47, blue: 39, alpha: 1)
        connectionNotificationLBL.textColor = UIColor.white
        connectionNotificationLBL.textAlignment = .center
        connectionNotificationLBL.font = UIFont(name: "System", size: 12)
        
        //Enable auto layout
        connectionNotificationLBL.anchor(top: nil, leading: onView.leadingAnchor, bottom: onView.safeAreaLayoutGuide.bottomAnchor, trailing: onView.trailingAnchor)
    }
    
    func dismissNetNotificationView(onView:UIView){
        for view in onView.subviews{
            if view.tag == 999{
                view.removeFromSuperview()
            }
        }
    }
}
