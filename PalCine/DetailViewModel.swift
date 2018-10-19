//
//  DetailViewModel.swift
//  PalCine
//
//  Created by Oscar Santos on 9/22/18.
//  Copyright © 2018 Oscar Santos. All rights reserved.
//

import UIKit
import CoreData

class DetailViewModel {

    var posterImg: UIImage!
    var backdropImg: UIImage!
    var title: String!
    var averaje: String!
    var releaseDate: String!
    var overview: String!
    var genres:NSArray = []
    var id: String!
    var credits = [CastViewModel]()
    var isFavorite:Bool!
    let notRatingLBL = UILabel()
    let releaseDateUnknownLBL = UILabel()
    
    let webservice = WebService.sharedInstance
    var movieToDetails:Movie?
    var castListVM:CastListViewModel!
    var movieDelegate:movieImageDownloadDelegate?
    private var completion :() -> () = {}
    
    
    init(movie:Movie, completion:@escaping () -> ()){
        self.movieToDetails = movie
        self.completion = completion
        checkIfIsFav()
        
        if isFavorite{
            print("es favorita")
            
        }else{
            print("NO es favorita")
        }
        
    }
    
    func setUp(){
        backdropImg = UIImage.createBackdropPlaceholderImage()!
        getBackdropImage(backdropUrl: (movieToDetails?.backdropUrl)!)
        posterImg = movieToDetails?.posterImg
        title = movieToDetails?.title
        id = movieToDetails?.movieID
        averaje = movieToDetails?.averageScore
        releaseDate = movieToDetails?.releaseDate
        overview = movieToDetails?.overview
        genres = (movieToDetails?.genres)!
        checkMovieStoryline()
        checkIfNotRated()
        checkIfNotHasReleaseDate()
        
        castListVM = CastListViewModel(movieID: self.id, completion: {
            self.getCast()
        })
    }
    
    func getCast() {
        self.credits.removeAll()
        self.credits = castListVM.castViewModels
        self.completion()
        getTrailerKey(key: id)
    }
    
    func getBackdropImage(backdropUrl:String){
        webservice.getMovieBackdropImage(BackdropUrl: backdropUrl) { (complete, success, result) in
            if success{
                self.backdropImg = result!
                self.movieDelegate?.backdropDownloadComplete!(image: result!)
            }
        }
    }
    func getTrailerKey(key:String){
        webservice.getMovieTrailer(movieID: key) { (success, result) in
            if success{
                self.movieDelegate?.trailerKeyDownloadComplete!(key: result!)
            }
        }
    }
    
    //MARK: Check for Empty & Favorite
    
    fileprivate func checkIfIsFav() {
        //print("movie id : \(movieToDetails?.movieID)")
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", (movieToDetails?.movieID)!)
        do{
            let result = try PersistanceService.context.fetch(request)
            if result.count > 0{
                self.isFavorite = true
                guard let theMovie = result.last else {return print("fallo la peli")}
                self.setUpFromDB(movie: theMovie)
            }else{
                self.isFavorite = false
                self.setUp()
            }
        }catch{}
    }
    
    fileprivate func checkMovieStoryline() {
        if movieToDetails?.overview == ""{
            overview = "No Story found"
        }
    }
    
    fileprivate func checkIfNotRated() {
        if averaje == "0"{
            
            notRatingLBL.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            notRatingLBL.textColor = UIColor.gray
            notRatingLBL.text = "Not rated"
            notRatingLBL.numberOfLines = 0
            notRatingLBL.setContentHuggingPriority(.defaultLow, for: .vertical)
            notRatingLBL.setContentCompressionResistancePriority(.required, for: .vertical)
            notRatingLBL.minimumScaleFactor = 1
            notRatingLBL.adjustsFontSizeToFitWidth = true
            
        }
    }
    
    fileprivate func checkIfNotHasReleaseDate() {
        if releaseDate == ""{
            
            releaseDateUnknownLBL.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            releaseDateUnknownLBL.textColor = UIColor.gray
            releaseDateUnknownLBL.text = "Release date unknown"
            releaseDateUnknownLBL.numberOfLines = 0
            releaseDateUnknownLBL.setContentHuggingPriority(.defaultLow, for: .vertical)
            releaseDateUnknownLBL.setContentCompressionResistancePriority(.required, for: .vertical)
            releaseDateUnknownLBL.minimumScaleFactor = 1
            releaseDateUnknownLBL.adjustsFontSizeToFitWidth = true
            
        }
    }
    
    // End -- Check for Empty & Favorite
    ///////////////////////////////////////////
    
    func setUpFromDB(movie:MovieEntity){
        posterImg = UIImage(data: (movie.poster as Data?)!)
        backdropImg = UIImage(data: (movie.backdrop as Data?)!)
        id = movie.id
        title = movie.title
        print("movie from db title : \(movie.title ?? "titulo")")
        averaje = movie.score
        releaseDate = movie.releaseDate
        overview = movie.overview
        genres = movie.genres!
        checkMovieStoryline()
        checkIfNotRated()
        checkIfNotHasReleaseDate()
        
        let request:NSFetchRequest<CastEntity> = CastEntity.fetchRequest()
        request.predicate = NSPredicate(format: "castMovieRelation == %@", movie)
        do{
            let results = try PersistanceService.context.fetch(request)
            if results.count > 0{
                for c in results{
                    let cast = CastViewModel(castFromDB: c)
                    self.credits.append(cast)
                }
                self.completion()
                getTrailerKey(key: id)
            }
        }catch{}
        
    }


}
