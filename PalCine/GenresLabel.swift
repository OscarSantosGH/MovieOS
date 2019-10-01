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
        backgroundColor = UIColor(named: "MOSgenderLabelBG")
        layer.cornerRadius = 7
        textColor = UIColor(named: "MOSsecondLabel")
        clipsToBounds = true
        font = UIFont.systemFont(ofSize: 12)
    }
    let genresArr = ["Action","Adventure","Animation","Comedy","Crime","Documentary","Drama","Family","Fantasy","History","Horror","Music","Mystery","Romance","Science Fiction","TV Movie","Thriller","War","Western"]
}
