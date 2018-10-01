//
//  FeatureMovieViewModel.swift
//  PalCine
//
//  Created by Oscar Santos on 9/17/18.
//  Copyright © 2018 Oscar Santos. All rights reserved.
//

import UIKit

class FeatureMovieViewModel {
    
    var backdropImg:UIImage = UIImage()
    var backdropUrl:String
    var title:String
    var overview:String
    var score:String
    
    let webservice = WebService.sharedInstance
    var movieVM:MovieViewModel
    private var completion :() -> () = {}
    
    init(movie:MovieViewModel, completion:@escaping () -> ()) {
        self.movieVM = movie
        self.title = movie.title
        self.overview = movie.overview
        self.score = movie.averageScore
        self.backdropUrl = movie.backdropUrl
        self.completion = completion
        self.getBackdropImg()
    }
    
    func getBackdropImg(){
        webservice.getMovieBackdropImage(BackdropUrl: backdropUrl) { (complete, success, image) in
            if success{
                self.backdropImg = image!
                self.completion()
            }
        }
    }
}
