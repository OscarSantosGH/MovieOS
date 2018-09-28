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
    var name:String = ""
    var character:String = ""
    var imageUrl:String = ""
    var photo:UIImage = UIImage()
    
    init(name:String, character:String, imageUrl:String) {
        self.name = name
        self.character = character
        self.imageUrl = imageUrl
        self.photo = UIImage(named: "placeholderCastImage")!
    }
    
    init(name:String, character:String, imageUrl:String, photo:UIImage) {
        self.name = name
        self.character = character
        self.imageUrl = imageUrl
        self.photo = photo
    }
    
}
