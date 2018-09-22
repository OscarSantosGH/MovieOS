//
//  MovieCollectionViewCell.swift
//  PalCine
//
//  Created by Oscar Santos on 5/4/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var ratingDescLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    var movie:MovieViewModel?
    
    func initalize(movie: MovieViewModel){
        self.movie = movie
        posterImageView.layer.cornerRadius = 5
        posterImageView.image = movie.posterImg
        titleLBL.text = movie.title
        checkIfNotRated()
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
    
    
}
