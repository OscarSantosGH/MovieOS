//
//  Movie.swift
//  PalCine
//
//  Created by Oscar Santos on 4/27/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

@objc protocol movieImageDownloadDelegate{
    @objc optional func posterDownloadComplete(image:UIImage)
    @objc optional func backdropDownloadComplete(image:UIImage)
    @objc optional func trailerKeyDownloadComplete(key:String)
}

class Movie {
    
    var title:String
    var averageScore:String
    var releaseDate:String
    var overview:String
    var posterUrl:String
    var backdropUrl:String
    var movieID:String
    var credits:[Cast]
    var genres:NSArray
    
    let manager = DataManager()
    var delegate:movieImageDownloadDelegate?
    
    init(movieID:String, title:String, averageScore:String, overview:String, posterUrl:String, backdropUrl:String, credits:[Cast], genres:NSArray, releaseDate:String) {
        self.movieID = movieID
        self.title = title
        self.averageScore = averageScore
        self.overview = overview
        self.posterUrl = posterUrl
        self.backdropUrl = backdropUrl
        self.credits = credits
        self.genres = genres
        self.releaseDate = releaseDate
    }
    
    
    func getPosterImage(){
        manager.getMoviePoster(posterUrl: posterUrl) { (complete, success, result) in
            if success{
                self.delegate?.posterDownloadComplete!(image: result!)
            }
        }
    }
    
    func getBackdropImage(){
        manager.getMovieBackdropImage(BackdropUrl: backdropUrl) { (complete, success, result) in
            if success{
                self.delegate?.backdropDownloadComplete!(image: result!)
            }
        }
    }
    
    func getTrailerKey(){
        manager.getMovieTrailer(movieID: movieID) { (success, result) in
            if success{
                self.delegate?.trailerKeyDownloadComplete!(key: result!)
            }
        }
    }
    
}
