//
//  MovieCategoryTableViewCell.swift
//  PalCine
//
//  Created by Oscar Santos on 11/1/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class MovieCategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
