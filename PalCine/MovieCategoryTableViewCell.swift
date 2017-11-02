//
//  MovieCategoryTableViewCell.swift
//  PalCine
//
//  Created by Oscar Santos on 11/1/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class MovieCategoryTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, MovieDownloadDelegate {
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    var movieManager = MovieManager.sharedInstance
    var movies = [Movie]()
    var thisCategory:moviesCategories = .Popular
    var isAllMoviesLoaded = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self
        movieManager.delegate = self
        
    }
    
    func setup(movieCategory:moviesCategories){
        switch movieCategory {
        case .Upcoming:
            movieManager.getUpComingMovies()
            thisCategory = .Upcoming
            categoryTitleLabel.text = "Upcoming"
        case .NowPlaying:
            movieManager.getPopularMovies()
            thisCategory = .Popular
            categoryTitleLabel.text = "Now Playing"
        default:
            movieManager.getPopularMovies()
            thisCategory = .Popular
            categoryTitleLabel.text = "Popular"
        }
    }
    
    // MARK: CollectionView Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let moviePos = movies[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! MovieCollectionViewCell
        cell.initalize(movie: moviePos)
        return cell
       
        
    }
    
    // MARK: CollectionView Delegate
    
    
    func timer() {
        //var timer = Timer()
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
            self.moviesCollectionView.reloadData()
        })
    }
    
    // MARK: MovieDownload Delegate
    func movieDownloadSuccess() {
        movies.removeAll()
        switch thisCategory {
        case .Upcoming:
            movies = movieManager.upComingMovies
        default:
            movies = movieManager.popularMovies
        }
        moviesCollectionView.reloadData()
        isAllMoviesLoaded = true
        //loadingMovies()
        print("movieDownloadSuccess")
        timer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
