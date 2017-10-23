//
//  MovieCollectionViewCell.swift
//  PalCine
//
//  Created by Oscar Santos on 5/4/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell, movieImageDownloadDelegate {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLBL: UILabel!
    
    var movie:Movie?
    
    func initalize(movie: Movie){
        self.movie = movie
        setupCell()
    }
    
    func setupCell(){
        movie?.delegate = self
        self.layer.cornerRadius = 10
        self.titleLBL.text = movie?.title
        movie?.getPosterImage()
    }
    
    func posterDownloadComplete(image:UIImage) {
        posterImageView.image = image
    }
}
