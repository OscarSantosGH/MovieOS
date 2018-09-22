//
//  DetailViewModel.swift
//  PalCine
//
//  Created by Oscar Santos on 9/22/18.
//  Copyright © 2018 Oscar Santos. All rights reserved.
//

import UIKit

class DetailViewModel: UIView {

    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var backdropImgView: UIImageView!
    @IBOutlet weak var porterImgView: UIImageView!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var averajeLBL: UILabel!
    @IBOutlet weak var overviewTxtView: UITextView!
    @IBOutlet weak var titleBgView: UIView!
    @IBOutlet weak var watchTrailerBTN: UIButton!
    @IBOutlet weak var genresView: UIStackView!
    @IBOutlet weak var releaseDateLBL: UILabel!
    @IBOutlet weak var ratingLBL: UILabel!
    @IBOutlet weak var ratingStackView: UIStackView!
    @IBOutlet weak var releaseDateTextLBL: UILabel!
    @IBOutlet weak var releaseDateStackView: UIStackView!
    @IBOutlet weak var storylineLBL: UILabel!
    @IBOutlet weak var theCastLBL: UILabel!
    @IBOutlet weak var curveShapeView: MovieDetailCurveShape!
    @IBOutlet weak var backdropContainerView: UIView!
    @IBOutlet weak var backdropFxView: UIVisualEffectView!
    
    @IBOutlet weak var castCollectionView: UICollectionView!
    
    

}
