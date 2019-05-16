//
//  FeatureMovieViewModel.swift
//  PalCine
//
//  Created by Oscar Santos on 9/17/18.
//  Copyright © 2018 Oscar Santos. All rights reserved.
//

import UIKit

class FeatureMovieViewModel {
    
    var backdropImg:UIImage
    var backdropUrl:String
    var title:String
    var overview:String
    var score:String
    
    let webservice = WebService.sharedInstance
    var movie:Movie
    private var completion :() -> () = {}
    
    init(movie:Movie, completion:@escaping () -> ()) {
        self.completion = completion
        self.movie = movie
        self.title = movie.title
        self.overview = movie.overview
        self.score = movie.averageScore
        self.backdropUrl = movie.backdropUrl
        self.backdropImg = UIImage.createBackdropPlaceholderImage()!
        self.getBackdropImg()
    }
    
    func getBackdropImg(){
        webservice.getMovieBackdropImage(BackdropUrl: backdropUrl) { [weak self] (complete, success, image) in
            if success{
                self?.backdropImg = image!
                self?.completion()
            }
        }
    }
}
