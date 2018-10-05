//
//  SearchViewController.swift
//  PalCine
//
//  Created by Oscar Santos on 9/8/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var webservice = WebService.sharedInstance
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
            DispatchQueue.main.async {
                self.setupView()
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
        })
        myCollectionView.dataSource = self.dataSource
        myCollectionView.reloadData()
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsSegue"{
            let destinationController = segue.destination as! DetailViewController
            let movie = sender as! Movie
            destinationController.movieToDetail = movie
            //destinationController.setupView()
        }
    }
 

}
