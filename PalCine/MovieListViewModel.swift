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
    
    var delegate:DownloadMovieStatusLabelUpdate?
    
    init(webservice:WebService, completion:@escaping () -> ()) {
        self.webservice = webservice
        self.completion = completion
        populateMovies()
    }
    
    func populateMovies(){
        delegate?.updateMoviesStatusLabel(msj: NSLocalizedString("Getting Popular movies...", comment: "Getting Popular movies Message"))
        self.webservice.getPopularMovies { [unowned self] (success, movies) in
            if success{
                self.popularMovieViewModels = movies.map(MovieViewModel.init)
                self.upComingMovies()
            }
        }
    }
    func upComingMovies(){
        delegate?.updateMoviesStatusLabel(msj: NSLocalizedString("Getting Upcomming movies...", comment: "Getting Upcomming movies Message"))
        self.webservice.getUpComingMovies { [unowned self] (success, movies) in
            if success{
                self.upComingMovieViewModels = movies.map(MovieViewModel.init)
                self.nowPlayingMovies()
            }
        }
    }
    func nowPlayingMovies(){
        delegate?.updateMoviesStatusLabel(msj: NSLocalizedString("Getting playing now movies...", comment: "Getting playing now movies Message"))
        self.webservice.getNowPlayingMovies { [unowned self] (success, movies) in
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
    
    let webservice = WebService.sharedInstance
    weak var delegate:movieImageDownloadDelegate?
    
    init(movie:Movie) {
        self.movie = movie
        self.title = movie.title
        self.averageScore = movie.averageScore
        self.posterImg = UIImage(named: "posterPlaceholder")!
        self.getPosterImage()
    }
    
    fileprivate func getPosterImage(){
        webservice.getMoviePoster(posterUrl: movie.posterUrl) { [weak self] (complete, success, result) in
            if success{
                self?.posterImg = result!
                self?.movie.posterImg = result!
                self?.delegate?.posterDownloadComplete!(image: result!)
            }
        }
    }
    
}
