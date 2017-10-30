//
//  ViewController.swift
//  PalCine
//
//  Created by Oscar Santos on 4/21/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MovieDownloadDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var movieManager = MovieManager.sharedInstance
    var movies = [Movie]()
    let searchBar = UISearchBar()
    var searchBtn = UIBarButtonItem()
    var bgButton = UIButton()
    var isAllMoviesLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingMovies()
        
        movieManager.getMovies()
        movieManager.delegate = self
        
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
        
        bgButton = UIButton(frame: self.view.frame)
        navSetting()
    }
    
    func loadingMovies(){
        if isAllMoviesLoaded {
            activityIndicator.stopAnimating()
            loadingView.removeFromSuperview()
        }else{
            self.view.addSubview(loadingView)
            loadingView.layer.cornerRadius = 50
            loadingView.center = view.center
            activityIndicator.startAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navSetting()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        bgButton.removeFromSuperview()
    }
    
    
    func navSetting(){
        searchBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.search, target: self, action: #selector(ViewController.searchBtnFunc))
        self.navigationItem.setRightBarButton(searchBtn, animated: true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        navigationController?.navigationBar.tintColor = .gray
        var colors = [UIColor]()
        colors.append(UIColor.rgb(red: 249, green: 249, blue: 249, alpha: 1))
        colors.append(UIColor.rgb(red: 249, green: 249, blue: 249, alpha: 1))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    
    // MARK: CollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return movies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let moviePos = movies[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MovieCollectionViewCell
            cell.initalize(movie: moviePos)
        return cell
    }
    
    // CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let selectedMovie = movies[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsSegue", sender: selectedMovie)
        self.navigationItem.titleView = nil
    }
    
    // MovieDownload Delegate
    func movieDownloadSuccess() {
        movies = movieManager.popularMovies
        myCollectionView.reloadData()
        isAllMoviesLoaded = true
        loadingMovies()
    }
    
    
    //Search Button Func
    @objc func searchBtnFunc() {
        searchBar.placeholder = "Search your movies"
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        
        bgButton.backgroundColor = UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 0.7)
        bgButton.addTarget(self, action: #selector(ViewController.cancelSearch), for: UIControlEvents.touchUpInside)
        self.view.addSubview(bgButton)
        
    }
    
    @objc func cancelSearch(){
        self.navigationItem.titleView = nil
        self.navigationItem.setRightBarButton(searchBtn, animated: true)
        myCollectionView.isHidden = false
        bgButton.removeFromSuperview()
    }
    
    //Search Bar Delegate
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar){
        cancelSearch()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        self.navigationItem.titleView = nil
        self.navigationItem.setRightBarButton(searchBtn, animated: true)
        
        guard let textForSearch = searchBar.text else { return }
        self.performSegue(withIdentifier: "toSearchResultSegue", sender: textForSearch)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsSegue"{
            let destinationController = segue.destination as! DetailViewController
            let movie = sender as! Movie
            destinationController.movieToDetail = movie
            destinationController.setupView()
        }else if segue.identifier == "toSearchResultSegue"{
            let destinationController = segue.destination as! SearchViewController
            let searchStr = sender as! String
            destinationController.searchString = searchStr
            destinationController.setupView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

