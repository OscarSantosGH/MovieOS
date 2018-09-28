//
//  GenderTagStackVIew.swift
//  PalCine
//
//  Created by Oscar Santos on 9/28/18.
//  Copyright © 2018 Oscar Santos. All rights reserved.
//

import UIKit

class GenderTagStackVIew: UIStackView {

    var mGenres:NSArray = []
    var isFirstGenreLoad = true
    
    func populate(with gendersArr:NSArray) {
        self.mGenres = gendersArr
        checkMovieGenres()
    }
    
    fileprivate func checkMovieGenres() {
        if mGenres == []{
            self.removeFromSuperview()
        }else{
            for item in mGenres{
                let key = item as! Int
                addGenreLabelView(forText: genresDic[key]!)
            }
        }
    }
    
    func getNewRowStackView() -> UIStackView{
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.alignment = .center
        rowStackView.distribution = .equalSpacing
        rowStackView.spacing = 2
        return rowStackView
    }
    
    func addGenreLabelView(forText text:String){
        let label = GenresLabel()
        label.text = "  " + text + "  "
        
        if isFirstGenreLoad{
            guard let placeholderStackView = self.arrangedSubviews.last else {return}
            placeholderStackView.removeFromSuperview()
            let newRowStackView = getNewRowStackView()
            newRowStackView.addArrangedSubview(label)
            self.addArrangedSubview(newRowStackView)
            isFirstGenreLoad = false
        }else{
            let lastRowStackView = self.arrangedSubviews.last as! UIStackView
            lastRowStackView.layoutIfNeeded()
            if (lastRowStackView.frame.width + label.intrinsicContentSize.width) < self.frame.width{
                lastRowStackView.addArrangedSubview(label)
                self.addArrangedSubview(lastRowStackView)
            }else{
                let newRowStackView = getNewRowStackView()
                newRowStackView.addArrangedSubview(label)
                self.addArrangedSubview(newRowStackView)
            }
        }
        
    }

}
