//
//  CastCollectionViewCell.swift
//  PalCine
//
//  Created by Oscar Santos on 8/25/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit
import AlamofireImage

class CastCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var castImageView: UIImageView!
    @IBOutlet weak var castName: UILabel!
    @IBOutlet weak var castCharacter: UILabel!
    
    var actor:CastViewModel?
    var index:Int?
    var delegate:MovieCastDelegate?
    var castPhoto: UIImage = UIImage(){
        didSet{
            if castPhoto != oldValue {
                //self.delegate?.castPosterDownloadComplete()
                self.updateFocusIfNeeded()
                self.setNeedsDisplay()
            }
        }
    }
    
    func setupCell(credits:CastViewModel) {
        actor = credits
        castImageView.layer.cornerRadius = 5
        castName.text = actor?.name
        castCharacter.text = actor?.character
        castPhoto = (actor?.photo)!
        castImageView.image = castPhoto
        
    }
    
    func setupCell2(withMovie cast:CastEntity, andImage image:UIImage) {
        castImageView.layer.cornerRadius = 5
        castName.text = cast.name
        castCharacter.text = cast.character
        castImageView.image = image
    }
    
}
