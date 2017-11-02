//
//  LoadingScreenViewController.swift
//  PalCine
//
//  Created by Oscar Santos on 11/2/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class LoadingScreenViewController: UIViewController, MovieDownloadDelegate {

    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var loadingStatusLabel: UILabel!
    
    var movieManager = MovieManager.sharedInstance
    var moviesCategoriesArr:Array<moviesCategories> = []
    var fetchMovieCategoryPos = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieManager.delegate = self
        activityIndicatorView.startAnimating()
        moviesCategoriesArr = [.Popular, .Upcoming]
        fetchAllMovies()
    }
    
    func fetchAllMovies(){
        let category = moviesCategoriesArr[fetchMovieCategoryPos]
        switch category {
        case .Upcoming:
            movieManager.getUpComingMovies()
            loadingStatusLabel.text = "Getting upcoming movies"
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
            activityIndicatorView.stopAnimating()
            self.performSegue(withIdentifier: "toHome", sender: self)
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! HomeViewController
        destinationVC.moviesCategoriesArr = self.moviesCategoriesArr
        destinationVC.popularMovies = movieManager.popularMovies
        destinationVC.upcomingMovies = movieManager.upComingMovies
    }
    

}
