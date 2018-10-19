//
//  PlayTrailerButton.swift
//  PalCine
//
//  Created by Oscar Santos on 10/17/18.
//  Copyright © 2018 Oscar Santos. All rights reserved.
//

import UIKit

class PlayTrailerButton:UIView {
    
    var playImg:UIImageView!
    var dimmer:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        dimmer = UIView(frame: frame)
        playImg = UIImageView(frame: frame)
        createBtn(rect: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createBtn(rect:CGRect) {
        self.frame = rect
        dimmer.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 0.2)
        dimmer.bounds = self.frame
        dimmer.center = self.center
        self.insertSubview(dimmer, at: 1)
        
        playImg.image = UIImage(named: "playBtn")
        playImg.contentMode = .scaleAspectFit
        
        playImg.center = self.center
        self.insertSubview(playImg, at: 2)
        
        playImg.translatesAutoresizingMaskIntoConstraints = false
        playImg.leadingAnchor.constraint(equalTo: dimmer.leadingAnchor, constant: 20).isActive = true
        playImg.trailingAnchor.constraint(equalTo: dimmer.trailingAnchor, constant: -20).isActive = true
        playImg.centerXAnchor.constraint(equalTo: dimmer.centerXAnchor).isActive = true
        playImg.centerYAnchor.constraint(equalTo: dimmer.centerYAnchor).isActive = true
    }
    
}
