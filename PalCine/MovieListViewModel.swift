//
//  MovieListViewModel.swift
//  PalCine
//
//  Created by Oscar Santos on 8/30/18.
//  Copyright © 2018 Oscar Santos. All rights reserved.
//

import UIKit

class MovieListViewModel {
    private var webservice :WebService
    var popularMovieViewModels :[MovieViewModel] = [MovieViewModel]()
    var upComingMovieViewModels :[MovieViewModel] = [MovieViewModel]()
    var nowPlayingMovieViewModels :[MovieViewModel] = [MovieViewModel]()
    private var completion :() -> () = {}
    
    init(webservice:WebService, completion:@escaping () -> ()) {
        self.webservice = webservice
        self.completion = completion
        populateMovies()
    }
    
    func populateMovies(){
        self.webservice.getPopularMovies { (success, movies) in
            if success{
                self.popularMovieViewModels = movies.map(MovieViewModel.init)
                self.upComingMovies()
            }
        }
    }
    func upComingMovies(){
        self.webservice.getUpComingMovies { (success, movies) in
            if success{
                self.upComingMovieViewModels = movies.map(MovieViewModel.init)
                self.nowPlayingMovies()
            }
        }
    }
    func nowPlayingMovies(){
        self.webservice.getNowPlayingMovies { (success, movies) in
            if success{
                self.nowPlayingMovieViewModels = movies.map(MovieViewModel.init)
                self.completion()
            }
        }
    }
}

class MovieViewModel {
    
    var title:String
    var averageScore:String
    var releaseDate:String
    var overview:String
    var posterUrl:String
    var posterImg:UIImage
    var backdropUrl:String
    var movieID:String
    var credits:[Cast]
    var genres:NSArray
    
    private var completion :() -> () = {}
    
    let webservice = WebService.sharedInstance
    var delegate:movieImageDownloadDelegate?
    
    init(movie:Movie) {
        self.movieID = movie.movieID
        self.title = movie.title
        self.averageScore = movie.averageScore
        self.overview = movie.overview
        self.posterUrl = movie.posterUrl
        self.posterImg = UIImage()
        self.backdropUrl = movie.backdropUrl
        self.credits = movie.credits
        self.genres = movie.genres
        self.releaseDate = movie.releaseDate
        self.getPosterImage()
    }
    
    fileprivate func getPosterImage(){
        webservice.getMoviePoster(posterUrl: posterUrl) { (complete, success, result) in
            if success{
                self.posterImg = result!
            }
        }
    }
    
    func getBackdropImage(){
        webservice.getMovieBackdropImage(BackdropUrl: backdropUrl) { (complete, success, result) in
            if success{
                self.delegate?.backdropDownloadComplete!(image: result!)
            }
        }
    }
    
    func getTrailerKey(){
        webservice.getMovieTrailer(movieID: movieID) { (success, result) in
            if success{
                self.delegate?.trailerKeyDownloadComplete!(key: result!)
            }
        }
    }
    
    func getCreditsArr(){
        webservice.getMovieCredits(movieID: movieID) { (success, response) in
            if success{
                if let cast = response["Credits"]{
                    let castArr = cast as! NSArray
                    var castLimit = 6
                    var currentIndex = 0
                    
                    if castArr.count <= castLimit{
                        if castArr.count <= 0{
                            self.credits = [Cast]()
                            self.delegate?.castDownloadComplete!(success: false)
                        }else{
                            castLimit = castArr.count
                        }
                    }
                    for c in castArr{
                        if currentIndex < castLimit{
                            let theCast:NSDictionary = c as! NSDictionary
                            var cName = ""
                            var cCharacter = ""
                            var cImageUrl = ""
                            
                            if let name = theCast["name"]{
                                cName = (name as? String)!
                            }else{
                                cName = "Null"
                            }
                            if let character = theCast["character"]{
                                cCharacter = (character as? String)!
                            }else{
                                cCharacter = "Null"
                            }
                            if let imageUrl = theCast["profile_path"]{
                                if let theUrl = imageUrl as? String{
                                    cImageUrl = theUrl
                                }else{
                                    cImageUrl = ""
                                }
                            }else{
                                cImageUrl = ""
                            }
                            
                            let newCast = Cast(name: cName, character: cCharacter, imageUrl: cImageUrl)
                            
                            self.credits.append(newCast)
                            currentIndex = currentIndex + 1
                            
                            if currentIndex == castLimit{
                                self.delegate?.castDownloadComplete!(success: true)
                            }else{
                                //print("cast: \(currentIndex) / \(castLimit)")
                            }
                            
                        }
                    }
                    
                }else{
                    print("No tiene Credits")
                }
            }else{
                print("Fallo el request")
                self.delegate?.castDownloadComplete!(success: false)
            }
        }
    }
}
