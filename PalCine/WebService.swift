//
//  DataManager.swift
//  PalCine
//
//  Created by Oscar Santos on 4/21/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

typealias GetMovieHandlerOld = (_ success:Bool, _ response:[String:AnyObject]) -> ()
typealias GetMovieHandler = (_ success:Bool, _ movies:[Movie]) -> ()
typealias GetCastHandler = (_ success:Bool, _ cast:[Cast]) -> ()
typealias GetTrailerHandler = (_ success:Bool, _ response:String?) -> ()
typealias GetPosterHandler = (_ complete:Bool,_ success:Bool, _ response:UIImage?) -> ()

class WebService {
    
    //MARK: - Proterties
    let popularUrl = "https://api.themoviedb.org/3/movie/popular?api_key=4e13bf065c2b0863199edfb0d78715d8&language=en-US&page=1"
    let upComingUrl = "https://api.themoviedb.org/3/movie/upcoming?api_key=4e13bf065c2b0863199edfb0d78715d8&language=en-US&page=1"
    let nowPlayingUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key=4e13bf065c2b0863199edfb0d78715d8&language=en-US&page=1"
    let baseImgUrl = "https://image.tmdb.org/t/p/w154"
    let baseBackdropImgUrl = "https://image.tmdb.org/t/p/w500"
    let baseCastImgUrl = "https://image.tmdb.org/t/p/w92"
    
    static let sharedInstance = WebService()
    
    private init(){}
    
    func getPopularMovies(completion:@escaping GetMovieHandler){
        Alamofire.request(popularUrl).responseJSON { response in
            if let error = response.error{
                print("Error: \(error.localizedDescription)")
                completion(false, [Movie]())
            }else{
                if response.response?.statusCode == 200{
                    if let JSON:NSDictionary = response.result.value as? NSDictionary{
                        if let result = JSON["results"]{
                            var movies = [Movie]()
                            let moviesDictionary = result as! [[String:AnyObject]]
                             movies = moviesDictionary.compactMap(Movie.init)
                             completion(true, movies)
                            
                            
                        }
                    }
                }else{
                    completion(false, [Movie]())
                }
            }
        }
    }
    
    func getUpComingMovies(completion:@escaping GetMovieHandler){
        Alamofire.request(upComingUrl).responseJSON { response in
            if let error = response.error{
                print("Error: \(error.localizedDescription)")
                completion(false, [Movie]())
            }else{
                if response.response?.statusCode == 200{
                    if let JSON:NSDictionary = response.result.value as? NSDictionary{
                        if let result = JSON["results"]{
                            var movies = [Movie]()
                            let moviesDictionary = result as! [[String:AnyObject]]
                            movies = moviesDictionary.compactMap(Movie.init)
                            completion(true, movies)
                        }
                    }
                }else{
                    completion(false, [Movie]())
                }
            }
        }
    }
    
    func getNowPlayingMovies(completion:@escaping GetMovieHandler){
        Alamofire.request(nowPlayingUrl).responseJSON { response in
            if let error = response.error{
                print("Error: \(error.localizedDescription)")
                completion(false, [Movie]())
            }else{
                if response.response?.statusCode == 200{
                    if let JSON:NSDictionary = response.result.value as? NSDictionary{
                        if let result = JSON["results"]{
                            var movies = [Movie]()
                            let moviesDictionary = result as! [[String:AnyObject]]
                            movies = moviesDictionary.compactMap(Movie.init)
                            completion(true, movies)
                        }
                    }
                }else{
                    completion(false, [Movie]())
                }
            }
        }
    }
    
    func getMovieCredits(movieID:String, completion:@escaping GetCastHandler){
        let pathString = "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=4e13bf065c2b0863199edfb0d78715d8"
        let urlRequest:URLRequestConvertible = URLRequest(url: URL(string: pathString)!)
        Alamofire.request(urlRequest).responseJSON { response in
            if let error = response.error{
                print("Error: \(error.localizedDescription)")
                completion(false, [Cast]())
            }else{
                if response.response?.statusCode == 200{
                    if let JSON:NSDictionary = response.result.value as? NSDictionary{
                        if let result = JSON["cast"]{
                            var castArr = [Cast]()
                            
                            castArr = self.castJSONParse(json: ["Credits" : result as AnyObject])
                            completion(true, castArr)
                        }
                    }
                }else{
                    completion(false, [Cast]())
                }
            }
        }
    }
    
    func getMovieBySearch(search:String, completion:@escaping GetMovieHandlerOld){
        let pathString = "https://api.themoviedb.org/3/search/movie?api_key=4e13bf065c2b0863199edfb0d78715d8&language=en-US&query=\(search)&page=1&include_adult=false"
        let urlRequest:URLRequestConvertible = URLRequest(url: URL(string: pathString)!)
        Alamofire.request(urlRequest).responseJSON { response in
            if let error = response.error{
                print("Error: \(error.localizedDescription)")
                completion(false, ["Error" : error.localizedDescription as AnyObject])
            }else{
                if response.response?.statusCode == 200{
                    if let JSON:NSDictionary = response.result.value as? NSDictionary{
                        if let result = JSON["results"]{
                            completion(true, ["Movies" : result as AnyObject])
                        }
                    }
                }else{
                    completion(false, ["Error" : response.error?.localizedDescription as AnyObject])
                }
            }
        }
    }
    
    func getMovieTrailer(movieID:String, completion:@escaping GetTrailerHandler){
        let pathString = "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=4e13bf065c2b0863199edfb0d78715d8&language=en-US"
        let urlRequest:URLRequestConvertible = URLRequest(url: URL(string: pathString)!)
        Alamofire.request(urlRequest).responseJSON { response in
            if let error = response.error{
                print("Error: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            }else{
                if response.response?.statusCode == 200{
                    if let JSON:NSDictionary = response.result.value as? NSDictionary{
                        if let result = JSON["results"]{
                            let castArr = result as! NSArray
                            if castArr == []{
                                completion(true, "")
                            }
                            guard let first = castArr.firstObject else {return}
                            let theCast:NSDictionary = first as! NSDictionary
                            if let name = theCast["key"]{
                               completion(true, name as? String)
                            }
                        }
                    }
                }else{
                    completion(false, response.error?.localizedDescription)
                }
            }
        }
    }
    
    
    func getMoviePoster(posterUrl:String, completion:@escaping GetPosterHandler) {
        let pathString = "\(baseImgUrl)\(posterUrl)"
        let urlRequest:URLRequestConvertible = URLRequest(url: URL(string: pathString)!)
        Alamofire.request(urlRequest).responseImage { response in
            if response.response?.statusCode == 200{
                if let image = response.result.value {
                    completion(true,true, image)
                }
            }else{
                completion(true,true, UIImage(named: "posterPlaceholder"))
                print("Fallo la descarga del poster")
            }
            print("response status code \(String(describing: response.response?.statusCode))")
        }
        
    }
    
    func getMovieBackdropImage(BackdropUrl:String, completion:@escaping GetPosterHandler) {
        let pathString = "\(baseBackdropImgUrl)\(BackdropUrl)"
        let urlRequest:URLRequestConvertible = URLRequest(url: URL(string: pathString)!)
        Alamofire.request(urlRequest).responseImage { response in
            if response.response?.statusCode == 200{
                if let image = response.result.value {
                    completion(true,true, image)
                }
            }else{
                completion(true,true, UIImage.createBackdropPlaceholderImage()!)
            }
            
        }
        
    }
    
    func getMovieCastImage(castUrl:String, completion:@escaping GetPosterHandler) {
        let pathString = "\(baseCastImgUrl)\(castUrl)"
        let urlRequest:URLRequestConvertible = URLRequest(url: URL(string: pathString)!)
        Alamofire.request(urlRequest).responseImage { response in
            if response.response?.statusCode == 200{
                if let image = response.result.value {
                    completion(true,true, image)
                }
            }else{
                completion(true,true, UIImage(named: "placeholderCastImage"))
            }
            
        }
        
    }
    
    private func castJSONParse(json:[String:AnyObject]) -> [Cast]{
        var credits = [Cast]()
        if let cast = json["Credits"]{
            let castArr = cast as! NSArray
            var castLimit = 10
            var currentIndex = 0
            
            if castArr.count <= castLimit{
                if castArr.count <= 0{
                    credits = [Cast]()
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
                    
                    credits.append(newCast)
                    currentIndex = currentIndex + 1
                    
//                    if currentIndex == castLimit{
//                        return credits
//                    }
                }
            }
        }
        return credits
    }
    
    
    
    
}
