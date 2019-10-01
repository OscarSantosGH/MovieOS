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
    
    //INSERT YOU OWN API KEY HERE
    let API_KEY = "4e13bf065c2b0863199edfb0d78715d8"
    
    var popularUrl:String!
    var upComingUrl:String!
    var nowPlayingUrl:String!
    let baseImgUrl = "https://image.tmdb.org/t/p/w154"
    let baseBackdropImgUrl = "https://image.tmdb.org/t/p/w500"
    let baseCastImgUrl = "https://image.tmdb.org/t/p/w92"
    
    var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    static let sharedInstance = WebService()
    
    private init(){
        popularUrl = "https://api.themoviedb.org/3/movie/popular?api_key=\(API_KEY)&language=en-US&page=1"
        upComingUrl = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(API_KEY)&language=en-US&page=1"
        nowPlayingUrl = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(API_KEY)&language=en-US&page=1"
    }
    
    let net = NetworkReachabilityManager(host: "www.apple.com")
    func startNetworkReachabilityObserver(){
        net?.listener = { status in
            switch status {
                
            case .reachable(.ethernetOrWiFi):
                let name = Notification.Name(rawValue: "com.oscarsantos.hasInternet")
                NotificationCenter.default.post(name: name, object: nil)
            case .reachable(.wwan):
                let name = Notification.Name(rawValue: "com.oscarsantos.hasInternet")
                NotificationCenter.default.post(name: name, object: nil)
            case .notReachable:
                let name = Notification.Name(rawValue: "com.oscarsantos.notInternet")
                NotificationCenter.default.post(name: name, object: nil)
            case .unknown :
                let name = Notification.Name(rawValue: "com.oscarsantos.notInternet")
                NotificationCenter.default.post(name: name, object: nil)
            }
        }
        net?.startListening()
    }
    
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
        let pathString = "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=\(API_KEY)"
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
    
    func getMovieBySearch(search:String, completion:@escaping GetMovieHandler){
        let pathString = "https://api.themoviedb.org/3/search/movie?api_key=\(API_KEY)&language=en-US&query=\(search)&page=1&include_adult=false"
        let urlRequest:URLRequestConvertible = URLRequest(url: URL(string: pathString)!)
        Alamofire.request(urlRequest).responseJSON { response in
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
    
    func getMovieTrailer(movieID:String, completion:@escaping GetTrailerHandler){
        let pathString = "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=\(API_KEY)&language=en-US"
        let urlRequest:URLRequestConvertible = URLRequest(url: URL(string: pathString)!)
        Alamofire.request(urlRequest).responseJSON { response in
            if let error = response.error{
                print("Error: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            }else{
                if response.response?.statusCode == 200{
                    if let JSON:NSDictionary = response.result.value as? NSDictionary{
                        if let result = JSON["results"]{
                            let videosArr = result as! NSArray
                            if videosArr == []{
                                completion(true, "")
                            }
                            guard let first = videosArr.firstObject else {return}
                            let theVid:NSDictionary = first as! NSDictionary
                            if let name = theVid["key"]{
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
                }
            }
        }
        return credits
    }
}
