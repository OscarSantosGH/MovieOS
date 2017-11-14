//
//  LoadingScreenViewController.swift
//  PalCine
//
//  Created by Oscar Santos on 11/2/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class LoadingScreenViewController: UIViewController, MovieDownloadDelegate, movieImageDownloadDelegate {

    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var loadingStatusLabel: UILabel!
    
    var movieManager = MovieManager.sharedInstance
    var moviesCategoriesArr:Array<moviesCategories> = []
    var fetchMovieCategoryPos = 0
    var featuredMovie:Movie?
    var featureMovieImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieManager.delegate = self
        activityIndicatorView.startAnimating()
        moviesCategoriesArr = [.Popular, .Upcoming, .NowPlaying]
        fetchAllMovies()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func fetchAllMovies(){
        let category = moviesCategoriesArr[fetchMovieCategoryPos]
        switch category {
        case .Upcoming:
            movieManager.getUpComingMovies()
            loadingStatusLabel.text = "Getting upcoming movies"
        case .NowPlaying:
            movieManager.getNowPlayingMovies()
            loadingStatusLabel.text = "Getting now playing movies"
        default:
            movieManager.getPopularMovies()
            loadingStatusLabel.text = "Getting popular movies"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func movieDownloadSuccess(){
        if fetchMovieCategoryPos < (moviesCategoriesArr.count - 1){
            fetchMovieCategoryPos = fetchMovieCategoryPos + 1
            fetchAllMovies()
        }else{
            pickFeatureMovie()
        }
    }
    
    func backdropDownloadComplete(image:UIImage) {
        featureMovieImage = image
        activityIndicatorView.stopAnimating()
        self.performSegue(withIdentifier: "toHome", sender: self)
    }
    
    func pickFeatureMovie(){
        let randomPos = arc4random_uniform(UInt32(movieManager.popularMovies.count))
        let randomMovie = movieManager.popularMovies[Int(randomPos)]
        randomMovie.delegate = self
        randomMovie.getBackdropImage()
        featuredMovie = randomMovie
        loadingStatusLabel.text = "Getting featured movie"
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationTapbarController = segue.destination as! UITabBarController
        let destinationNavigationController = destinationTapbarController.viewControllers?.first as! UINavigationController
        let destinationVC = destinationNavigationController.topViewController as! HomeViewController
        destinationVC.moviesCategoriesArr = self.moviesCategoriesArr
        destinationVC.popularMovies = movieManager.popularMovies
        destinationVC.upcomingMovies = movieManager.upComingMovies
        destinationVC.nowPlayingMovies = movieManager.nowPlayingMovies
        destinationVC.featuredMovie = featuredMovie
        destinationVC.featureMovieImage = featureMovieImage
    }
    

}
