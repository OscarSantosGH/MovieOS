//
//  Movie.swift
//  PalCine
//
//  Created by Oscar Santos on 4/27/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

@objc protocol movieImageDownloadDelegate{
    @objc optional func posterDownloadComplete(image:UIImage)
    @objc optional func backdropDownloadComplete(image:UIImage)
    @objc optional func trailerKeyDownloadComplete(key:String)
    @objc optional func castDownloadComplete(success:Bool)
}

class Movie {
    
    var title:String
    var averageScore:String
    var releaseDate:String
    var overview:String
    var posterUrl:String
    var backdropUrl:String
    var movieID:String
    var credits:[Cast]
    var genres:NSArray
    
    let manager = DataManager()
    var delegate:movieImageDownloadDelegate?
    
    init(movieID:String, title:String, averageScore:String, overview:String, posterUrl:String, backdropUrl:String, genres:NSArray, releaseDate:String) {
        self.movieID = movieID
        self.title = title
        self.averageScore = averageScore
        self.overview = overview
        self.posterUrl = posterUrl
        self.backdropUrl = backdropUrl
        self.credits = [Cast]()
        self.genres = genres
        self.releaseDate = releaseDate
    }
    
    
    func getPosterImage(){
        manager.getMoviePoster(posterUrl: posterUrl) { (complete, success, result) in
            if success{
                self.delegate?.posterDownloadComplete!(image: result!)
            }
        }
    }
    
    func getBackdropImage(){
        manager.getMovieBackdropImage(BackdropUrl: backdropUrl) { (complete, success, result) in
            if success{
                self.delegate?.backdropDownloadComplete!(image: result!)
            }
        }
    }
    
    func getTrailerKey(){
        manager.getMovieTrailer(movieID: movieID) { (success, result) in
            if success{
                self.delegate?.trailerKeyDownloadComplete!(key: result!)
            }
        }
    }
    
    func getCreditsArr(){
        manager.getMovieCredits(movieID: movieID) { (success, response) in
            if success{
                if let cast = response["Credits"]{
                    let castArr = cast as! NSArray
                    var castLimit = 6
                    var currentIndex = 0
                    
                    if castArr.count <= castLimit{
                        if castArr.count <= 0{
                            self.credits = [Cast]()
                            self.delegate?.castDownloadComplete!(success: false)
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
                            
                            self.credits.append(newCast)
                            currentIndex = currentIndex + 1
                            
                            if currentIndex == castLimit{
                                self.delegate?.castDownloadComplete!(success: true)
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
                self.delegate?.castDownloadComplete!(success: false)
            }
        }
    }
    
}
