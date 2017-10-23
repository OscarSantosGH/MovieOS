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

typealias GetMovieHandler = (_ success:Bool, _ response:[String:AnyObject]) -> ()
typealias GetTrailerHandler = (_ success:Bool, _ response:String?) -> ()
typealias GetPosterHandler = (_ complete:Bool,_ success:Bool, _ response:UIImage?) -> ()

class DataManager {
    
    //MARK: - Proterties
    let url = "https://api.themoviedb.org/3/movie/popular?api_key=4e13bf065c2b0863199edfb0d78715d8&language=en-US&page=1"
    let baseImgUrl = "https://image.tmdb.org/t/p/w160"
    let baseBackdropImgUrl = "https://image.tmdb.org/t/p/w500"
    let baseCastImgUrl = "https://image.tmdb.org/t/p/w92"
    
    func getPopularMovies(completion:@escaping GetMovieHandler){
        Alamofire.request(url).responseJSON { response in
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
    
    func getMovieCredits(movieID:String, completion:@escaping GetMovieHandler){
        let pathString = "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=4e13bf065c2b0863199edfb0d78715d8"
        let urlRequest:URLRequestConvertible = URLRequest(url: URL(string: pathString)!)
        Alamofire.request(urlRequest).responseJSON { response in
            if let error = response.error{
                print("Error: \(error.localizedDescription)")
                completion(false, ["Error" : error.localizedDescription as AnyObject])
            }else{
                if response.response?.statusCode == 200{
                    if let JSON:NSDictionary = response.result.value as? NSDictionary{
                        if let result = JSON["cast"]{
                            completion(true, ["Credits" : result as AnyObject])
                        }
                    }
                }else{
                    completion(false, ["Error" : response.error?.localizedDescription as AnyObject])
                }
            }
        }
    }
    
    func getMovieBySearch(search:String, completion:@escaping GetMovieHandler){
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
            }
            
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
                completion(true,true, UIImage(named: "backdropPlaceholder"))
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
    
}
