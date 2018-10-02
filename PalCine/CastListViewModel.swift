//
//  CastListViewModel.swift
//  PalCine
//
//  Created by Oscar Santos on 9/22/18.
//  Copyright © 2018 Oscar Santos. All rights reserved.
//

import UIKit

class CastListViewModel {
    
    var movieID:String!
    let webService = WebService.sharedInstance
    var castViewModels:[CastViewModel] = [CastViewModel]()
    var completion: () -> () = {}
    
    init(movieID:String, completion:@escaping()->()){
        self.movieID = movieID
        self.completion = completion
        getTheCast()
    }
    
    func getTheCast(){
        webService.getMovieCredits(movieID: movieID) { (success, cast) in
            if success{
                self.castViewModels = cast.compactMap(CastViewModel.init)
                self.completion()
            }
        }
    }

}

class CastViewModel {
    let name:String
    let character:String
    let imageUrl:String
    var photo:UIImage
    
    let webService = WebService.sharedInstance
    
    init(name:String, character:String, imageUrl:String) {
        self.name = name
        self.character = character
        self.imageUrl = imageUrl
        self.photo = UIImage(named: "placeholderCastImage")!
    }
    
    init(cast:Cast) {
        self.name = cast.name
        self.character = cast.character
        self.imageUrl = cast.imageUrl
        self.photo = UIImage(named: "placeholderCastImage")!
        getCastImage()
    }
    
    init(castFromDB:CastEntity) {
        self.name = castFromDB.name!
        self.character = castFromDB.character!
        self.photo = UIImage(data: castFromDB.photo! as Data)!
        self.imageUrl = ""
    }
    
    private func getCastImage() {
        webService.getMovieCastImage(castUrl: imageUrl) { (complete, success, result) in
            if success{
                self.photo = result!
            }
        }
    }
    
    func convertToCast() -> Cast{
        let cast = Cast(name: self.name, character: self.character, imageUrl: self.imageUrl, photo: self.photo)
        return cast
    }
    
}
