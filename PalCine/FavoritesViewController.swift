//
//  FavoritesViewController.swift
//  PalCine
//
//  Created by Oscar Santos on 11/17/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var favTableView: UITableView!
    
    var favoriteListVM:FavoriteListViewModel!
    var favMovieArr:[FavoriteViewModel] = [FavoriteViewModel]()
    var dataSource:MyTableViewDataSource<FeatureMovieTableViewCell, FavoriteViewModel>!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favTableView.delegate = self
        
        favoriteListVM = FavoriteListViewModel(completion: {
            DispatchQueue.main.async {
                self.populateTheTable()
            }
        })
    }
    
    func populateTheTable(){
        favMovieArr = favoriteListVM.favoriteViewModels
        
        self.dataSource = MyTableViewDataSource(cellIdentifier: "featureMovieCell", items: favMovieArr, configureCell: { (cell, vm) in
            cell.setupView(withMovie: vm.getMovie(), andImage: vm.backdropImg)
        })
        favTableView.dataSource = self.dataSource
        favTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 160
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let selectedMovie = favMovieArr[indexPath.row]
        print(selectedMovie)
        performSegue(withIdentifier: "toDetailsSegue", sender: selectedMovie.getMovie())
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsSegue"{
            let destinationController = segue.destination as! DetailViewController
            let movie = sender as! Movie
            destinationController.movieToDetail = movie
        }
    }
 

}
