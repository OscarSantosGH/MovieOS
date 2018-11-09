//
//  FeatureMovieTableViewCell.swift
//  PalCine
//
//  Created by Oscar Santos on 11/3/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit

class FeatureMovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var storylineLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var colors = [UIColor]()
        colors.append(UIColor.rgb(red: 36, green: 38, blue: 47, alpha: 1))
        colors.append(UIColor.rgb(red: 36, green: 38, blue: 47, alpha: 0))
        gradientView.setGradientBG(colors: colors)
    }
    
    func setupView(withMovie movie:Movie, andImage image:UIImage){
        movieImageView.image = image
        movieTitleLabel.text = movie.title
        storylineLabel.text = movie.overview
        ratingLabel.text = movie.averageScore
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
