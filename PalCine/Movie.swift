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
    
    var title:String = ""
    var averageScore:String = ""
    var releaseDate:String = ""
    var overview:String = ""
    var posterUrl:String = ""
    var posterImg:UIImage
    var backdropUrl:String = ""
    var backdropImg:UIImage
    var movieID:String = ""
    var credits:[Cast] = [Cast]()
    var genres:NSArray = []
    
    init(){
        title = ""
        averageScore = ""
        releaseDate = ""
        overview = ""
        posterUrl = ""
        posterImg = UIImage(named: "posterPlaceholder")!
        backdropUrl = ""
        backdropImg = UIImage.createBackdropPlaceholderImage()!
        movieID = ""
        credits = [Cast]()
        genres = []
    }
    
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
        self.posterImg = UIImage(named: "posterPlaceholder")!
        self.backdropImg = UIImage.createBackdropPlaceholderImage()!
    }
    
    init?(json:[String:AnyObject]){
        
        if let id = json["id"]{
            self.movieID  = (String(describing: id))
        }
        
        if let ntitle = json["title"]{
            if let tTitle = ntitle as? String{
                self.title = tTitle
            }else{
                self.title = "Title not found"
            }
        }else{
            self.title = "Title not found"
        }
        
        if let average = json["vote_average"]{
            let str = String(describing: average)
            let nsString = str as NSString
            if nsString.length > 0{
                self.averageScore = nsString.substring(with: NSRange(location: 0, length: nsString.length > 3 ? 3 : nsString.length))
            }else{
                self.averageScore = "0"
            }
        }else{
            self.averageScore = "0"
        }
        
        if let nOverview = json["overview"]{
            self.overview = (nOverview as? String)!
        }
        
        if let releaseDate = json["release_date"]{
            if let tReleaseDate = releaseDate as? String{
                self.releaseDate = tReleaseDate
            }else{
                self.releaseDate = ""
            }
        }else{
            self.releaseDate = ""
        }
        
        
        
        if let poster = json["poster_path"]{
            if let tPosterUrl = poster as? String{
                self.posterUrl = tPosterUrl
            }else{
                self.posterUrl = ""
            }
            
        }
        if let backdrop = json["backdrop_path"]{
            if let backdropUrl = backdrop as? String{
                self.backdropUrl = backdropUrl
            }else{
                self.backdropUrl = ""
            }
            
        }
        if let genres = json["genre_ids"]{
            let genresArr = genres as! NSArray
            if genresArr.count > 0 {
                self.genres = genresArr
            }else{
                self.genres = []
            }
        }
        self.posterImg = UIImage(named: "posterPlaceholder")!
        self.backdropImg = UIImage.createBackdropPlaceholderImage()!
        self.credits = [Cast]()
    }
    
    
}
