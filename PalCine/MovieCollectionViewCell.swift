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
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var ratingDescLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var movie:Movie?
    
    func initalize(movie: Movie){
        self.movie = movie
        setupCell()
    }
    
    func setupCell(){
        movie?.delegate = self
        self.layer.cornerRadius = 10
        self.titleLBL.text = movie?.title
        checkIfNotRated()
        movie?.getPosterImage()
    }
    
    fileprivate func checkIfNotRated(){
        if movie?.averageScore == "0"{
            ratingLabel.isHidden = true
            ratingDescLabel.text = "Not Rated"
        }else{
            if let rating = movie?.averageScore{
                ratingLabel.text = rating
            }else{
                ratingLabel.text = "?"
            }
            
        }
    }
    
    func posterDownloadComplete(image:UIImage) {
        posterImageView.image = image
    }
}
