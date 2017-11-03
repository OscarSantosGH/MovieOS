//
//  HomeViewController.swift
//  PalCine
//
//  Created by Oscar Santos on 10/31/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var moviesByCategoryTableView: UITableView!
    
    var moviesCategoriesArr:Array<moviesCategories> = []
    var popularMovies = [Movie]()
    var upcomingMovies = [Movie]()
    var nowPlayingMovies = [Movie]()
    var featuredMovie:Movie?
    var featureMovieImage = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesByCategoryTableView.dataSource = self
        moviesByCategoryTableView.delegate = self
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.leftBarButtonItem?.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesCategoriesArr.count + 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.row == 0{
            let cell =  tableView.dequeueReusableCell(withIdentifier: "featureMovieCell", for: indexPath) as! FeatureMovieTableViewCell
            cell.setupView(withMovie: featuredMovie!, andImage: featureMovieImage)
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
        let moviePos:Movie?
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
        let selectedMovie:Movie?
        if collectionView.tag == 1{
            selectedMovie = upcomingMovies[indexPath.item]
        }else if collectionView.tag == 2{
            selectedMovie = nowPlayingMovies[indexPath.item]
        }else{
            selectedMovie = popularMovies[indexPath.item]
        }
        self.performSegue(withIdentifier: "toDetailsSegue", sender: selectedMovie!)
        self.navigationItem.titleView = nil
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsSegue"{
            let destinationController = segue.destination as! DetailViewController
            let movie = sender as! Movie
            destinationController.movieToDetail = movie
            destinationController.setupView()
        }
    }
    

}
