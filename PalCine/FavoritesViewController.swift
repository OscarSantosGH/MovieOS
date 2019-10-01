//
//  FavoritesViewController.swift
//  PalCine
//
//  Created by Oscar Santos on 11/17/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class FavoritesViewController: RootViewController, UITableViewDelegate {
    
    @IBOutlet weak var favTableView: UITableView!
    
    var favoriteListVM:FavoriteListViewModel!
    var favMovieArr:[FavoriteViewModel] = [FavoriteViewModel]()
    var dataSource:MyTableViewDataSource<FeatureMovieTableViewCell, FavoriteViewModel>!
    
    var noFavMovieView: NoFavoriteMovieView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favTableView.delegate = self
        
        favoriteListVM = FavoriteListViewModel(completion: { [weak self] in
            DispatchQueue.main.async {
                self?.populateTheTable()
            }
        })
    }
    
    func populateTheTable(){
        favMovieArr = favoriteListVM.favoriteViewModels
        
        if favMovieArr.isEmpty{
            favTableView.isHidden = true
            if noFavMovieView != nil{
                noFavMovieView?.isHidden = false
            }else{
                noFavMovieView = NoFavoriteMovieView(frame: self.view.frame)
                self.view.addSubview(noFavMovieView!)
            }
        }else{
            favTableView.isHidden = false
            if noFavMovieView != nil{
                noFavMovieView?.isHidden = true
            }
            self.dataSource = MyTableViewDataSource(cellIdentifier: "featureMovieCell", items: favMovieArr, configureCell: { (cell, vm) in
                cell.setupView(withMovie: vm.getMovie(), andImage: vm.backdropImg)
            })
            favTableView.dataSource = self.dataSource
            favTableView.reloadData()
        }
    }
    
    //MARK: NavigationBar functions
    override func setBeforePopNavigationColors() {
        navigationController?.navigationBar.tintColor = UIColor(named: "MOSfisrtLabel")
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear]
        self.preferredStatusBarStyle = UIStatusBarStyle.lightContent
    }
    
    override func setNavigationColors(){
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: "MOSfisrtLabel")!]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "MOSfisrtLabel")!]
            navBarAppearance.backgroundColor = UIColor.systemBackground
            navBarAppearance.shadowColor = .clear
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }else{
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController?.navigationBar.shadowImage = UIImage()
        }
        navigationController?.navigationBar.tintColor = UIColor(named: "MOSfisrtLabel")
        navigationController?.navigationBar.barStyle = UIBarStyle.default
        self.preferredStatusBarStyle = UIStatusBarStyle.default
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
