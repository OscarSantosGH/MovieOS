//
//  LoadingScreenViewController.swift
//  PalCine
//
//  Created by Oscar Santos on 11/2/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class LoadingScreenViewController: UIViewController {

    @IBOutlet weak var loadingImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var loadingStatusLabel: UILabel!
    
    let webservice = WebService.sharedInstance
    var movieListViewModel:MovieListViewModel!
    var featureMovieViewModel:FeatureMovieViewModel?
    var popularMovies = [MovieViewModel]()
    var upcomingMovies = [MovieViewModel]()
    var nowPlayingMovies = [MovieViewModel]()
    var featuredMovie:FeatureMovieViewModel?
    var featureMovieImage = UIImage()
    
    let userDefault = UserDefaults.standard
    let hasInternetNotificationName = Notification.Name(rawValue: "com.oscarsantos.hasInternet")
    let notInternetNotificationName = Notification.Name(rawValue: "com.oscarsantos.notInternet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicatorView.startAnimating()
        self.navigationController?.navigationBar.isHidden = true
        setObservers()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        print(" LoadingScreen has been deinit")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    func setObservers() {
        webservice.startNetworkReachabilityObserver()
        NotificationCenter.default.addObserver(self, selector: #selector(LoadingScreenViewController.initialSetup), name: hasInternetNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoadingScreenViewController.initialSetup), name: notInternetNotificationName, object: nil)
    }
    
    @objc func initialSetup(){
        loadingStatusLabel.text = "Getting movies..."
        if userDefault.bool(forKey: "secondTime"){
            if webservice.isConnectedToInternet{
                loadingStatusLabel.text = "Getting movies..."
            }else{
                loadingStatusLabel.text = "Proceeding without internet"
            }
            self.movieListViewModel = MovieListViewModel(webservice: webservice, completion: { [unowned self] in
                self.fetchAllMovies()
            })
        }else{
            
            if webservice.isConnectedToInternet{
                loadingStatusLabel.text = "Getting movies..."
                self.movieListViewModel = MovieListViewModel(webservice: webservice, completion: { [unowned self] in
                    self.userDefault.set(true, forKey: "secondTime")
                    self.fetchAllMovies()
                })
            }else{
                loadingStatusLabel.text = "Please connect to the internet to proceed"
            }
        }
    }
    
    func fetchAllMovies(){
        popularMovies = movieListViewModel.popularMovieViewModels
        upcomingMovies = movieListViewModel.upComingMovieViewModels
        nowPlayingMovies = movieListViewModel.nowPlayingMovieViewModels
        self.pickFeatureMovie()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setFeatureMovie() {
        featuredMovie = featureMovieViewModel
        featureMovieImage = (featureMovieViewModel?.backdropImg)!
        activityIndicatorView.stopAnimating()
        self.performSegue(withIdentifier: "toHome", sender: self)
    }
    
    func pickFeatureMovie(){
        let randomPos = arc4random_uniform(UInt32(popularMovies.count))
        let randomMovie = popularMovies[Int(randomPos)]
        
        self.featureMovieViewModel = FeatureMovieViewModel(movie: randomMovie.movie, completion: { [unowned self] in
            self.setFeatureMovie()
        })
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationTapbarController = segue.destination as! UITabBarController
        let destinationNavigationController = destinationTapbarController.viewControllers?.first as! UINavigationController
        let destinationVC = destinationNavigationController.topViewController as! HomeViewController
        destinationVC.popularMovies = self.popularMovies.shuffled()
        destinationVC.upcomingMovies = self.upcomingMovies.shuffled()
        destinationVC.nowPlayingMovies = self.nowPlayingMovies.shuffled()
        destinationVC.featuredMovie = self.featuredMovie
        destinationVC.featureMovieImage = self.featureMovieImage
        
    }

}
