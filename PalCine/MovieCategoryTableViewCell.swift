//
//  MovieCategoryTableViewCell.swift
//  PalCine
//
//  Created by Oscar Santos on 11/1/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class MovieCategoryTableViewCell: UITableViewCell, MovieDownloadDelegate {
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    var movieManager = MovieManager.sharedInstance
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieManager.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func movieDownloadSuccess() {
        moviesCollectionView.reloadData()
        print("movieDownloadSuccess")
    }

}
