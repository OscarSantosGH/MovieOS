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
    
    func setupCell(credits:CastViewModel) {
        actor = credits
        castImageView.layer.cornerRadius = 5
        castName.text = actor?.name
        castCharacter.text = actor?.character
        castImageView.image = actor?.photo
        
        //actor?.delegate = self
        //actor?.getCastImage(castUrl: (actor?.imageUrl)!)
        
    }
    
    func setupCell2(withMovie cast:CastEntity, andImage image:UIImage) {
        castImageView.layer.cornerRadius = 5
        castName.text = cast.name
        castCharacter.text = cast.character
        castImageView.image = image
    }
    
}
