//
//  MovieManager.swift
//  PalCine
//
//  Created by Oscar Santos on 5/3/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

protocol MovieDownloadDelegate {
    func movieDownloadSuccess()
}

class MovieManager {
    
    private enum MovieRequestType {
        case Pupular
        case UpComing
        case Search
    }
    
    static let sharedInstance = MovieManager()
    
    private init(){}
    
    let manager = DataManager()
    var popularMovies = [Movie]()
    var upComingMovies = [Movie]()
    var searchedMovies = [Movie]()
    var delegate:MovieDownloadDelegate?
    
    func getPopularMovies(){
        manager.getPopularMovies { success, response in
            if success{
                self.popularMovies.removeAll()
                self.movieJSONParse(json: response, type: MovieRequestType.Pupular)
            }else{
               print("Fallo el getPopularMovies")
            }
        }
    }
    
    func getUpComingMovies(){
        manager.getUpComingMovies { success, response in
            if success{
                self.upComingMovies.removeAll()
                self.movieJSONParse(json: response, type: MovieRequestType.UpComing)
            }else{
                print("Fallo el getUpComingMovies")
            }
        }
    }
    
    func getMoviesByString(searchString:String){
        manager.getMovieBySearch(search: searchString) { success, response in
            if success{
                self.searchedMovies.removeAll()
                self.movieJSONParse(json: response, type: MovieRequestType.Search)
            }else{
                print("Fallo el getMovieBySearch")
            }
        }
    }
    
   private func movieJSONParse(json:[String:AnyObject], type:MovieRequestType){
        if let movie = json["Movies"]{
            let movieList = movie as! NSArray
            var totalMoviesDownload = 0
            for m in movieList{
                let theMovie:NSDictionary = m as! NSDictionary
                var theMtitle:String = ""
                var theMaverageScore:String = "0"
                var theMreleaseDate:String = ""
                var theMoverview:String = ""
                var theMposterName:String = ""
                var theMbackdropName:String = ""
                var theMid:String = ""
                var theMcredits = [Cast]()
                var theMgenres:NSArray = []
                
                if let title = theMovie["title"]{
                    if let tTitle = title as? String{
                        theMtitle = tTitle
                    }else{
                        theMtitle = "Title not found"
                    }
                }else{
                    theMtitle = "Title not found"
                }
                
                if let average = theMovie["vote_average"]{
                    let str = String(describing: average)
                    let nsString = str as NSString
                    if nsString.length > 0{
                        theMaverageScore = nsString.substring(with: NSRange(location: 0, length: nsString.length > 3 ? 3 : nsString.length))
                    }else{
                        theMaverageScore = "0"
                    }
                    
                }else{
                    theMaverageScore = "0"
                }
                
                if let overview = theMovie["overview"]{
                    theMoverview = (overview as? String)!
                }
                
                if let releaseDate = theMovie["release_date"]{
                    if let tReleaseDate = releaseDate as? String{
                        theMreleaseDate = tReleaseDate
                    }else{
                        theMreleaseDate = ""
                    }
                }else{
                    theMreleaseDate = ""
                }
                
                if let poster = theMovie["poster_path"]{
                    if let posterUrl = poster as? String{
                        theMposterName = posterUrl
                    }else{
                        theMposterName = ""
                    }
                    
                }
                if let backdrop = theMovie["backdrop_path"]{
                    if let backdropUrl = backdrop as? String{
                        theMbackdropName = backdropUrl
                    }else{
                        theMbackdropName = ""
                    }
                    
                }
                if let genres = theMovie["genre_ids"]{
                    let genresArr = genres as! NSArray
                    if genresArr.count > 0 {
                        theMgenres = genresArr
                    }else{
                        theMgenres = []
                    }
                }
                if let id = theMovie["id"]{
                    theMid = (String(describing: id))
                    
                    self.manager.getMovieCredits(movieID: theMid) { (success, response) in
                        
                        if success{
                            if let cast = response["Credits"]{
                                let castArr = cast as! NSArray
                                var castLimit = 6
                                var currentIndex = 0
                                
                                if castArr.count <= castLimit{
                                    if castArr.count <= 0{
                                        addMovie()
                                    }else{
                                        castLimit = castArr.count
                                    }
                                }
                                for c in castArr{
                                    if currentIndex < castLimit{
                                        let theCast:NSDictionary = c as! NSDictionary
                                        var cName = ""
                                        var cCharacter = ""
                                        var cImageUrl = ""
                                        
                                        if let name = theCast["name"]{
                                            cName = (name as? String)!
                                        }else{
                                            cName = "Null"
                                        }
                                        if let character = theCast["character"]{
                                            cCharacter = (character as? String)!
                                        }else{
                                            cCharacter = "Null"
                                        }
                                        if let imageUrl = theCast["profile_path"]{
                                            if let theUrl = imageUrl as? String{
                                                cImageUrl = theUrl
                                            }else{
                                                cImageUrl = ""
                                            }
                                        }else{
                                            cImageUrl = ""
                                        }
                                        
                                        let newCast = Cast(name: cName, character: cCharacter, imageUrl: cImageUrl)
                                        
                                        theMcredits.append(newCast)
                                        currentIndex = currentIndex + 1
                                        
                                        if currentIndex == castLimit{
                                            addMovie()
                                        }else{
                                            //print("cast: \(currentIndex) / \(castLimit)")
                                        }
                                        
                                    }
                                }
                                
                            }else{
                                print("No tiene Credits")
                            }
                        }else{
                            print("Fallo el request")
                            //addMovie()
                        }
                    }
                }else{
                    print("No tiene ID")
                }
                
                
                func addMovie(){
                    let newMovie = Movie(movieID: theMid, title: theMtitle, averageScore: theMaverageScore, overview: theMoverview, posterUrl: theMposterName, backdropUrl: theMbackdropName, credits: theMcredits, genres: theMgenres, releaseDate: theMreleaseDate)
                    switch type {
                    case .Search:
                        self.searchedMovies.append(newMovie)
                    break
                    case .UpComing:
                        self.upComingMovies.append(newMovie)
                        break
                    default:
                        self.popularMovies.append(newMovie)
                    }
                    totalMoviesDownload = totalMoviesDownload + 1
                    if totalMoviesDownload == movieList.count{
                        if self.delegate != nil{
                            self.delegate?.movieDownloadSuccess()
                        }
                    }
                }
            }
            
        }
    }
    
}
