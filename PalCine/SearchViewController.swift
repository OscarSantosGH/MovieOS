//
//  SearchViewController.swift
//  PalCine
//
//  Created by Oscar Santos on 9/8/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, MovieDownloadDelegate {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    var movieManager = MovieManager.sharedInstance
    var movies = [Movie]()
    
    var searchString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newString = searchString.replacingOccurrences(of: " ", with: "%20")
        movieManager.getMoviesByString(searchString: newString)
        movieManager.delegate = self
        
        myCollectionView.dataSource = self
        myCollectionView.delegate = self
    }
    
    func setupView(){
        self.navigationItem.title = searchString
    }
    
    // MovieDownload Delegate
    func movieDownloadSuccess() {
        movies = movieManager.searchedMovies
        myCollectionView.reloadData()
        myCollectionView.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // CollectionView Data Source
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
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsSegue"{
            let destinationController = segue.destination as! DetailViewController
            let movie = sender as! Movie
            destinationController.movieToDetail = movie
            destinationController.setupView()
        }
    }
 

}
