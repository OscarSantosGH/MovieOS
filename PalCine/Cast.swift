//
//  Cast.swift
//  PalCine
//
//  Created by Oscar Santos on 8/28/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

protocol MovieCastDelegate {
    func castPosterDownloadComplete(image:UIImage)
}

class Cast {
    let name:String
    let character:String
    let imageUrl:String
    
    let manager = DataManager()
    var delegate:MovieCastDelegate?
    
    init(name:String, character:String, imageUrl:String) {
        self.name = name
        self.character = character
        self.imageUrl = imageUrl
    }
    
    func getCastImage(castUrl:String){
        manager.getMovieCastImage(castUrl: castUrl) { (complete, success, result) in
            if success{
                self.delegate?.castPosterDownloadComplete(image: result!)
            }
        }
    }
}
