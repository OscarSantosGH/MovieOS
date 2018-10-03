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
    var posterImg:UIImage
    
    var movie:Movie
    
    private var completion :() -> () = {}
    
    let webservice = WebService.sharedInstance
    var delegate:movieImageDownloadDelegate?
    
    init(movie:Movie) {
        self.movie = movie
        self.title = movie.title
        self.averageScore = movie.averageScore
        self.posterImg = UIImage(named: "posterPlaceholder")!
        self.getPosterImage()
    }
    
//    init(movieFromDB:MovieEntity) {
//        self.title = movieFromDB.title!
//        self.averageScore = movieFromDB.score!
//        self.posterImg = UIImage(data: (movieFromDB.poster as Data?)!)!
//    }
    
    
    fileprivate func getPosterImage(){
        webservice.getMoviePoster(posterUrl: movie.posterUrl) { (complete, success, result) in
            if success{
                self.posterImg = result!
                self.movie.posterImg = result!
                self.delegate?.posterDownloadComplete!(image: result!)
            }
        }
    }
    
//    func getBackdropImage(){
//        webservice.getMovieBackdropImage(BackdropUrl: movie.backdropUrl) { (complete, success, result) in
//            if success{
//                self.delegate?.backdropDownloadComplete!(image: result!)
//            }
//        }
//    }
//
//    func getTrailerKey(){
//        webservice.getMovieTrailer(movieID: movie.movieID) { (success, result) in
//            if success{
//                self.delegate?.trailerKeyDownloadComplete!(key: result!)
//            }
//        }
//    }
    
    
}
