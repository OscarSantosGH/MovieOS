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
    
    var heartIcon:UIImageView?
    var noFavMovieTxt:UILabel?
    
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
        
        if favMovieArr.isEmpty{
            favTableView.isHidden = true
            if heartIcon != nil{
                heartIcon?.isHidden = false
            }else{
                heartIcon = UIImageView(image: UIImage(named: "EmptyHeart"))
                heartIcon?.contentMode = .scaleAspectFill
                self.view.addSubview(heartIcon!)
                heartIcon?.anchor(top: self.view.safeAreaLayoutGuide.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .init(top: self.view.frame.height/5, left: self.view.frame.width/2, bottom: 0, right: self.view.frame.width/2))
            }
            if noFavMovieTxt != nil{
                noFavMovieTxt?.isHidden = false
            }else{
                noFavMovieTxt = UILabel()
                noFavMovieTxt?.numberOfLines = 0
                noFavMovieTxt?.textAlignment = .center
                noFavMovieTxt?.textColor = UIColor.gray
                noFavMovieTxt?.font = UIFont(name: "HelveticaNeue", size: 25.0)!
                noFavMovieTxt?.text = "Touch the heart icon to save a movie"
                self.view.addSubview(noFavMovieTxt!)
                noFavMovieTxt?.anchor(top: heartIcon!.bottomAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, padding: .init(top: 30, left: self.view.frame.width/6, bottom: 0, right: self.view.frame.width/6))
            }
        }else{
            favTableView.isHidden = false
            if heartIcon != nil{
                heartIcon?.isHidden = true
            }
            if noFavMovieTxt != nil{
                noFavMovieTxt?.isHidden = true
            }
            self.dataSource = MyTableViewDataSource(cellIdentifier: "featureMovieCell", items: favMovieArr, configureCell: { (cell, vm) in
                cell.setupView(withMovie: vm.getMovie(), andImage: vm.backdropImg)
            })
            favTableView.dataSource = self.dataSource
            favTableView.reloadData()
        }
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
