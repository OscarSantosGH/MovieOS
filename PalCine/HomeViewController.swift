//
//  HomeViewController.swift
//  PalCine
//
//  Created by Oscar Santos on 10/31/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class HomeViewController: RootViewController, UISearchBarDelegate, NavigationBarReporting{
    
    var navTintColor: UIColor = UIColor(named: "MOSfisrtLabel") ?? UIColor.darkGray
    var showNavBarBG: Bool = true
    
    @IBOutlet weak var moviesByCategoryTableView: UITableView!
    @IBOutlet var loadingScreenView: LoadingScreenView!
    
    var moviesCategoriesArr:Array<moviesCategories> = []
    var popularMovies = [MovieViewModel]()
    var upcomingMovies = [MovieViewModel]()
    var nowPlayingMovies = [MovieViewModel]()
    var featuredMovie:FeatureMovieViewModel?
    var featureMovieImage = UIImage()
    let searchBar = UISearchBar()
    var searchBtn = UIBarButtonItem()
    var bgButton = UIButton()
    let webservice = WebService.sharedInstance
    let netNotificationView = NetNotificationView.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = navTintColor
        navigationItem.backBarButtonItem?.tintColor = navTintColor
        navigationController?.setNavigationBarHidden(true, animated: true)
        tabBarController?.setTabBar(hidden: true, animated: false)
        
        self.view.addSubview(loadingScreenView)
        loadingScreenView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: self.view.bottomAnchor, trailing: self.view.trailingAnchor)
        
        loadingScreenView.moviesLoadFinished { [weak self] (popular, upComing, nowPlaying, featuredMovie, featuredImage)  in
            self?.popularMovies = popular.shuffled()
            self?.upcomingMovies = upComing.shuffled()
            self?.nowPlayingMovies = nowPlaying.shuffled()
            self?.featuredMovie = featuredMovie
            self?.featureMovieImage = featuredImage
            self?.configView()
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bgButton.removeFromSuperview()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        if !webservice.isConnectedToInternet{
            lostConnection()
        }
        animate()
    }
    
    private func animate() {
        guard let coordinator = self.transitionCoordinator else {
            return
        }
        coordinator.animate(alongsideTransition: {
            [weak self] context in
            self?.navigationController?.navigationBar.tintColor = self?.navTintColor
            self?.navigationItem.backBarButtonItem?.tintColor = self?.navTintColor
            self?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: self?.navTintColor ?? UIColor.darkGray]
        }, completion: nil)
    }
    
    func configView(){
        navigationController?.setNavigationBarHidden(false, animated: true)
        tabBarController?.setTabBar(hidden: false)
        tabBarController?.tabBar.isTranslucent = true
        moviesByCategoryTableView.dataSource = self
        moviesByCategoryTableView.delegate = self
        moviesCategoriesArr = [.Popular, .Upcoming, .NowPlaying]
        
        searchBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(HomeViewController.searchBtnFunc))
        self.navigationItem.setRightBarButton(searchBtn, animated: true)
        
        bgButton = UIButton(frame: self.view.frame)
        setObservers()
        
        navigationItem.hidesBackButton = true
        moviesByCategoryTableView.reloadData()
        UIView.animate(withDuration: 0.5, animations: {
            self.loadingScreenView.alpha = 0
        }) { bool in
            self.loadingScreenView.removeFromSuperview()
        }
    }
    
    //MARK: NavigationBar functions
    override func setBeforePopNavigationColors() {
        self.preferredStatusBarStyle = UIStatusBarStyle.lightContent
    }

    override func setNavigationColors(){
        self.preferredStatusBarStyle = UIStatusBarStyle.default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Notifications
    func setObservers(){
        let hasInternetNotificationName = Notification.Name(rawValue: "com.oscarsantos.hasInternet")
        let notInternetNotificationName = Notification.Name(rawValue: "com.oscarsantos.notInternet")
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.findConnection), name: hasInternetNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.lostConnection), name: notInternetNotificationName, object: nil)
    }
    @objc func lostConnection(){
        netNotificationView.presentNetNotificationView(onView: self.view)
    }
    @objc func findConnection(){
        netNotificationView.dismissNetNotificationView(onView: self.view)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: search Button Func
    @objc func searchBtnFunc() {
        searchBar.placeholder = "Search your movies"
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()

        bgButton.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 0.7)
        bgButton.addTarget(self, action: #selector(HomeViewController.cancelSearch), for: UIControl.Event.touchUpInside)
        self.view.addSubview(bgButton)

    }

    @objc func cancelSearch(){
        self.navigationItem.titleView = nil
        self.navigationItem.setRightBarButton(searchBtn, animated: true)
        moviesByCategoryTableView.isHidden = false
        bgButton.removeFromSuperview()
        moviesByCategoryTableView.reloadData()
    }
    
    // MARK: Search Bar Delegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        cancelSearch()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.navigationItem.titleView = nil
        self.navigationItem.setRightBarButton(searchBtn, animated: true)

        guard let textForSearch = searchBar.text else { return }
        self.performSegue(withIdentifier: "toSearchResultSegue", sender: textForSearch)
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsSegue"{
            let destinationController = segue.destination as! DetailViewController
            let movie = sender as! Movie
            destinationController.movieToDetail = movie
        }else if segue.identifier == "toSearchResultSegue"{
            let destinationController = segue.destination as! SearchViewController
            let searchStr = sender as! String
            destinationController.searchString = searchStr
        }
    }
    

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesCategoriesArr.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.row == 0{
            let cell =  tableView.dequeueReusableCell(withIdentifier: "featureMovieCell", for: indexPath) as! FeatureMovieTableViewCell
            cell.movieTitleLabel.text = featuredMovie?.title
            cell.ratingLabel.text = featuredMovie?.score
            cell.storylineLabel.text = featuredMovie?.overview
            cell.movieImageView.image = featuredMovie?.backdropImg
            return cell
        }else{
            let thisCategory = moviesCategoriesArr[indexPath.row - 1]
            switch thisCategory {
            case .Upcoming:
                let cell =  tableView.dequeueReusableCell(withIdentifier: "movieCategoryCell", for: indexPath) as! MovieCategoryTableViewCell
                cell.moviesCollectionView.delegate = self
                cell.moviesCollectionView.dataSource = self
                cell.moviesCollectionView.tag = 1
                cell.categoryTitleLabel.text = "Upcoming"
                return cell
            case .NowPlaying:
                let cell =  tableView.dequeueReusableCell(withIdentifier: "movieCategoryCell", for: indexPath) as! MovieCategoryTableViewCell
                cell.moviesCollectionView.delegate = self
                cell.moviesCollectionView.dataSource = self
                cell.moviesCollectionView.tag = 2
                cell.categoryTitleLabel.text = "Now Playing"
                return cell
            default:
                let cell =  tableView.dequeueReusableCell(withIdentifier: "movieCategoryCell", for: indexPath) as! MovieCategoryTableViewCell
                cell.moviesCollectionView.delegate = self
                cell.moviesCollectionView.dataSource = self
                cell.moviesCollectionView.tag = 0
                cell.categoryTitleLabel.text = "Popular"
                return cell
            }
        }
    }
    // MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0{
            return 160
        }else{
            return 280
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if indexPath.row == 0{
            self.performSegue(withIdentifier: "toDetailsSegue", sender: featuredMovie?.movie)
        }
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    // MARK: CollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1{
            return upcomingMovies.count
        }else if collectionView.tag == 2{
            return nowPlayingMovies.count
        }else{
            return popularMovies.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let moviePos:MovieViewModel?
        if collectionView.tag == 1{
            moviePos = upcomingMovies[indexPath.item]
        }else if collectionView.tag == 2{
            moviePos = nowPlayingMovies[indexPath.item]
        }else{
            moviePos = popularMovies[indexPath.item]
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MovieCollectionViewCell
        cell.initalize(movie: moviePos!)
        return cell
    }
    // MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let selectedMovie:MovieViewModel?
        if collectionView.tag == 1{
            selectedMovie = upcomingMovies[indexPath.item]
        }else if collectionView.tag == 2{
            selectedMovie = nowPlayingMovies[indexPath.item]
        }else{
            selectedMovie = popularMovies[indexPath.item]
        }
        self.performSegue(withIdentifier: "toDetailsSegue", sender: selectedMovie?.movie)
        self.navigationItem.titleView = nil
    }
}
