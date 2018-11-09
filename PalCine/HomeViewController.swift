//
//  HomeViewController.swift
//  PalCine
//
//  Created by Oscar Santos on 10/31/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class HomeViewController: RootViewController, UISearchBarDelegate{
    
    @IBOutlet weak var moviesByCategoryTableView: UITableView!
    
    var moviesCategoriesArr:Array<moviesCategories> = []
    var popularMovies = [MovieViewModel]()
    var upcomingMovies = [MovieViewModel]()
    var nowPlayingMovies = [MovieViewModel]()
    var featuredMovie:FeatureMovieViewModel?
    var featureMovieImage = UIImage()
    let searchBar = UISearchBar()
    var searchBtn = UIBarButtonItem()
    var bgButton = UIButton()
    var webservice:WebService!
    var netNotificationView:NetNotificationView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesByCategoryTableView.dataSource = self
        moviesByCategoryTableView.delegate = self
        moviesCategoriesArr = [.Popular, .Upcoming, .NowPlaying]
        webservice = WebService.sharedInstance
        netNotificationView = NetNotificationView.sharedInstance
        
        searchBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.search, target: self, action: #selector(HomeViewController.searchBtnFunc))
        self.navigationItem.setRightBarButton(searchBtn, animated: true)
        
        bgButton = UIButton(frame: self.view.frame)
        setObservers()
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesBackButton = true
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
    }
    
    //MARK: NavigationBar functions
    override func setBeforePopNavigationColors() {
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        self.preferredStatusBarStyle = UIStatusBarStyle.lightContent
        guard let barBG = navigationController?.navigationBar.subviews.first else {return}
        guard let barBGfx = barBG.subviews.last else {return}
        barBGfx.alpha = 0
    }
    
    override func setNavigationColors(){
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor.darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.preferredStatusBarStyle = UIStatusBarStyle.default
        guard let barBG = navigationController?.navigationBar.subviews.first else {return}
        guard let barBGfx = barBG.subviews.last else {return}
        barBGfx.alpha = 1
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
        print("lost connection is called")
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
