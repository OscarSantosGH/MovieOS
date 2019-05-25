//
//  SearchListViewModel.swift
//  PalCine
//
//  Created by Oscar Santos on 10/5/18.
//  Copyright © 2018 Oscar Santos. All rights reserved.
//

import UIKit

class SearchListViewModel {
    
    var movieViewModels:[MovieViewModel] = [MovieViewModel]()
    private var webservice :WebService
    private var searchStr:String
    private var completion :() -> () = {}
    
    init(webservice:WebService, searchString:String, completion:@escaping () -> ()) {
        self.webservice = webservice
        self.searchStr = searchString
        self.completion = completion
        populateMovies()
    }
    
    func populateMovies(){
        let newString = searchStr.replacingOccurrences(of: " ", with: "%20")
        webservice.getMovieBySearch(search: newString) { [weak self] (success, movies) in
            if success{
                self?.movieViewModels = movies.map(MovieViewModel.init)
                self?.completion()
            }
        }
    }
}
