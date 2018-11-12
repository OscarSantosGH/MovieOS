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
        
        playImg.anchor(top: nil, leading: dimmer.leadingAnchor, bottom: nil, trailing: dimmer.trailingAnchor, padding: .init(top: 50, left: 20, bottom: 50, right: 20))
        playImg.centerAnchors(centerEqualTo: dimmer)
    }
}
