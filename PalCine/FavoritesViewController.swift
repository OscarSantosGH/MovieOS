//
//  FavoritesViewController.swift
//  PalCine
//
//  Created by Oscar Santos on 11/17/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var favTableView: UITableView!
    
    var favMovieArr = [MovieEntity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favTableView.dataSource = self
        favTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        do{
            let movies = try PersistanceService.context.fetch(fetchRequest)
            self.favMovieArr = movies
            favTableView.reloadData()
        }catch{
            print("ERROR fetching movies")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if favMovieArr.isEmpty{
            return 0
        }else{
            return favMovieArr.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell =  tableView.dequeueReusableCell(withIdentifier: "featureMovieCell", for: indexPath) as! FeatureMovieTableViewCell
        let currentMovie = favMovieArr[indexPath.row]
        let currentMovieBackdrop = UIImage(data: currentMovie.backdrop! as Data)
        cell.setupView2(withMovie: currentMovie, andImage: currentMovieBackdrop!)
        
        return cell
    }
    
    //MARK: TableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 160
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let selectedMovie = favMovieArr[indexPath.row]
        performSegue(withIdentifier: "toDetailsSegue", sender: selectedMovie)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsSegue"{
            let destinationController = segue.destination as! DetailViewController
            let movie = sender as! MovieEntity
            destinationController.movieToDetailFromDB = movie
            //destinationController.setupView()
            
        }
    }
 

}
