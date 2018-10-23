//
//  CastCollectionViewCell.swift
//  PalCine
//
//  Created by Oscar Santos on 8/25/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell, MovieCastDelegate {
    @IBOutlet weak var castImageView: UIImageView!
    @IBOutlet weak var castName: UILabel!
    @IBOutlet weak var castCharacter: UILabel!
    
    var actor:CastViewModel?
    var delegate:MovieCastDelegate?
    var anim:Animations!
    var castPhoto: UIImage = UIImage(){
        didSet{
            if castPhoto != oldValue {
                self.updateFocusIfNeeded()
                self.setNeedsDisplay()
            }
        }
    }
    
    func setupCell(credits:CastViewModel) {
        actor = credits
        actor?.castDelegate = self
        castImageView.layer.cornerRadius = 5
        castName.text = actor?.name
        castCharacter.text = actor?.character
        castPhoto = (actor?.photo)!
        castImageView.image = castPhoto
        
    }
    
    func castPosterDownloadComplete(image:UIImage){
        castPhoto = image
        castImageView.image = castPhoto
    }
    
    func makeItPlaceholder(){
        self.anim = Animations.shareInstance
        castImageView.image = UIImage()
        castName.text = "Name"
        castCharacter.text = "Character"
        anim.startLoading(views: [castImageView, castName, castCharacter])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
