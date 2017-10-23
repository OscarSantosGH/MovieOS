//
//  Genres.swift
//  PalCine
//
//  Created by Oscar Santos on 9/25/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

@IBDesignable
public class GenresLabel: UILabel {
    
    public override func didMoveToSuperview() {
        backgroundColor = UIColor.rgb(red: 241, green: 240, blue: 245, alpha: 1)
        layer.cornerRadius = 7
        textColor = UIColor.rgb(red: 95, green: 95, blue: 95, alpha: 1)
        clipsToBounds = true
        font = UIFont.systemFont(ofSize: 12)
    }
    let genresArr = ["Action","Adventure","Animation","Comedy","Crime","Documentary","Drama","Family","Fantasy","History","Horror","Music","Mystery","Romance","Science Fiction","TV Movie","Thriller","War","Western"]
}
