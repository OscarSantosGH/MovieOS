//
//  NoFavoriteMovieView.swift
//  MovieOS
//
//  Created by Oscar Santos on 9/30/19.
//  Copyright © 2019 Oscar Santos. All rights reserved.
//

import UIKit

class NoFavoriteMovieView: UIView {
    
    var heartIcon:UIImageView!
    var noFavMovieTxt:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heartIcon = UIImageView(frame: frame)
        createViews(rect: frame)
    }
    
    func createViews(rect: CGRect){
        self.frame = rect
        
        heartIcon.image = UIImage(named: "EmptyHeart")
        heartIcon.contentMode = .scaleAspectFit
        self.insertSubview(heartIcon, at: 1)
        
        noFavMovieTxt = UILabel()
        noFavMovieTxt.numberOfLines = 0
        noFavMovieTxt.textAlignment = .center
        noFavMovieTxt.textColor = UIColor(named: "MOSfisrtLabel")
        noFavMovieTxt.font = UIFont(name: "HelveticaNeue", size: 22.0)!
        noFavMovieTxt.text = "Touch the heart icon to save a movie"
        self.insertSubview(noFavMovieTxt, at: 2)
        
        heartIcon.anchor(top: self.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: self.frame.height/5, left: self.frame.width/2, bottom: 0, right: self.frame.width/2), size: .init(width: 88, height: 88))
        heartIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        noFavMovieTxt.anchor(top: heartIcon.bottomAnchor, leading: self.leadingAnchor, bottom: nil, trailing: self.trailingAnchor, padding: .init(top: 30, left: self.frame.width/6, bottom: 0, right: self.frame.width/6))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
