//
//  SearchViewController.swift
//  PalCine
//
//  Created by Oscar Santos on 9/8/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class SearchViewController: RootViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let webservice = WebService.sharedInstance
    let netNotificationView = NetNotificationView.sharedInstance
    var searchListVM:SearchListViewModel!
    var dataSource:MyCollectionViewDataSource<MovieCollectionViewCell,MovieViewModel>!
    var movies = [MovieViewModel]()
    
    var searchString = ""
    var isAllMoviesLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myCollectionView.delegate = self
        loadingMovies()
        
        searchListVM = SearchListViewModel(webservice: webservice, searchString: searchString, completion: {
            DispatchQueue.main.async { [weak self] in
                self?.setupView()
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = searchString
    }
    
    func setupView(){
        isAllMoviesLoaded = true
        loadingMovies()
        movies = searchListVM.movieViewModels
        self.dataSource = MyCollectionViewDataSource(cellIdentifier: "myCell", items: movies, configureCell: { (cell, vm) in
            cell.initalize(movie: vm)
            cell.layer.cornerRadius = 5
        })
        myCollectionView.dataSource = self.dataSource
        myCollectionView.reloadData()
    }
    
    //MARK: NavigationBar functions
    override func setBeforePopNavigationColors() {
        navigationController?.navigationBar.tintColor = UIColor(named: "MOSfisrtLabel")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        self.preferredStatusBarStyle = UIStatusBarStyle.lightContent
        guard let barBG = navigationController?.navigationBar.subviews.first else {return}
        guard let barBGfx = barBG.subviews.last else {return}
        barBGfx.alpha = 0
    }
    
    override func setNavigationColors(){
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor(named: "MOSfisrtLabel")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "MOSfisrtLabel")!]
        navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.preferredStatusBarStyle = UIStatusBarStyle.default
        guard let barBG = navigationController?.navigationBar.subviews.first else {return}
        guard let barBGfx = barBG.subviews.last else {return}
        barBGfx.alpha = 1
    }
    
    func loadingMovies(){
        if isAllMoviesLoaded {
            activityIndicator.stopAnimating()
            loadingView.removeFromSuperview()
        }else{
            self.view.addSubview(loadingView)
            loadingView.layer.cornerRadius = 30
            loadingView.center = view.center
            activityIndicator.startAnimating()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let selectedMovie = movies[indexPath.row]
        self.performSegue(withIdentifier: "toDetailsSegue", sender: selectedMovie.movie)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 3) - 16, height: 235)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsSegue"{
            let destinationController = segue.destination as! DetailViewController
            let movie = sender as! Movie
            destinationController.movieToDetail = movie
        }
    }
 

}
