//
//  FavoriteListViewModel.swift
//  PalCine
//
//  Created by Oscar Santos on 10/5/18.
//  Copyright © 2018 Oscar Santos. All rights reserved.
//

import UIKit
import CoreData

class FavoriteListViewModel {
    var favoriteViewModels :[FavoriteViewModel] = [FavoriteViewModel]()
    private var completion :() -> () = {}
    
    init(completion:@escaping () -> ()) {
        self.completion = completion
        getMoviesFromDB()
    }
    
    func getMoviesFromDB(){
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        do{
            let movies = try PersistanceService.context.fetch(fetchRequest)
            self.favoriteViewModels = movies.map(FavoriteViewModel.init)
            self.completion()
        }catch{
            //print("ERROR fetching movies")
        }
    }
}

class FavoriteViewModel {
    var backdropImg:UIImage
    var title:String
    var overview:String
    var score:String
    
    var movieEntity:MovieEntity!
    
    init(movieDB:MovieEntity) {
        self.movieEntity = movieDB
        backdropImg = UIImage(data: (movieDB.poster as Data?)!)!
        title = movieDB.title!
        overview = movieDB.overview!
        score = movieDB.score!
    }
    
    func getMovie() -> Movie {
        let movie = Movie(movieID: (movieEntity?.id)!, title: movieEntity.title!, averageScore: movieEntity.score!, overview: movieEntity.overview!, posterUrl: "", backdropUrl: "", genres: movieEntity.genres!, releaseDate: movieEntity.releaseDate!)
        return movie
    }
}
