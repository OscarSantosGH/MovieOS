//
//  LoadingScreenView.swift
//  MovieOS
//
//  Created by Oscar Santos on 10/7/19.
//  Copyright © 2019 Oscar Santos. All rights reserved.
//

import UIKit

class LoadingScreenView: UIView {
    
    //var iconImageView:UIImageView!
    //var activityIndicatorView = UIActivityIndicatorView()
    //var loadingStatusLabel = UILabel()
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var loadingStatusLabel: UILabel!
    
    
    let webservice = WebService.sharedInstance
    var movieListViewModel:MovieListViewModel!
    var featureMovieViewModel:FeatureMovieViewModel?
    var popularMovies = [MovieViewModel]()
    var upcomingMovies = [MovieViewModel]()
    var nowPlayingMovies = [MovieViewModel]()
    var featuredMovie:FeatureMovieViewModel?
    var featureMovieImage = UIImage()
    private var completion :(_ popular:[MovieViewModel], _ upcoming:[MovieViewModel], _ nowPlaying:[MovieViewModel], _ featuredMovie:FeatureMovieViewModel, _ featureMovieImage:UIImage) -> () = {_,_,_,_,_ in }
    
    let userDefault = UserDefaults.standard
    let hasInternetNotificationName = Notification.Name(rawValue: "com.oscarsantos.hasInternet")
    let notInternetNotificationName = Notification.Name(rawValue: "com.oscarsantos.notInternet")
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setObservers()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func awakeFromNib() {
       super.awakeFromNib()
       setObservers()
    }
    
    func moviesLoadFinished(completion:@escaping (_ popular:[MovieViewModel], _ upcoming:[MovieViewModel], _ nowPlaying:[MovieViewModel], _ featuredMovie:FeatureMovieViewModel, _ featureMovieImage:UIImage) -> ()){
        self.completion = completion
    }
    
    deinit {
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
        print("Fetching all movies")
        popularMovies = movieListViewModel.popularMovieViewModels
        upcomingMovies = movieListViewModel.upComingMovieViewModels
        nowPlayingMovies = movieListViewModel.nowPlayingMovieViewModels
        self.pickFeatureMovie()
    }
    
    func setFeatureMovie() {
        print("setting feature")
        featuredMovie = featureMovieViewModel
        featureMovieImage = (featureMovieViewModel?.backdropImg)!
        //self.performSegue(withIdentifier: "toHome", sender: self)
        NotificationCenter.default.removeObserver(self)
        self.completion(popularMovies, upcomingMovies, nowPlayingMovies, featuredMovie!, featureMovieImage)
    }
    
    func pickFeatureMovie(){
        print("picking feature")
        let randomPos = arc4random_uniform(UInt32(popularMovies.count))
        let randomMovie = popularMovies[Int(randomPos)]
        
        self.featureMovieViewModel = FeatureMovieViewModel(movie: randomMovie.movie, completion: { [unowned self] in
            self.setFeatureMovie()
        })
        
    }

}
