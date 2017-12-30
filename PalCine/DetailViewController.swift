//
//  DetailViewController.swift
//  PalCine
//
//  Created by Oscar Santos on 7/3/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, movieImageDownloadDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate{
    
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
    
    @IBOutlet weak var castCollectionView: UICollectionView!
    
    var shareBTN:UIBarButtonItem?
    var movieToDetail:Movie?
    var movieToDetailFromDB:MovieEntity?
    
    var mTitle = ""
    var mID = ""
    var mAverage = ""
    var mReleaseDate = ""
    var mOverview = ""
    var trailerKey = ""
    var mPosterImage = UIImage(named: "posterPlaceholder")
    var mBackdropImage = UIImage(named: "backdropPlaceholder")
    var mCredits = [Cast]()
    var mCredits2 = [CastEntity]()
    var mGenres:NSArray = []
    var isFirstGenreLoad = true
    var isFavorite = false
    var isMovieFromDB = false
    
    var castLabelString: String = "" {
        didSet{
            guard let castLabel = theCastLBL else {return}
            castLabel.text = castLabelString
        }
    }
    
    var myCollectionViewHeight: CGFloat = 0.0 {
        didSet {
            if myCollectionViewHeight != oldValue {
                castCollectionView.collectionViewLayout.invalidateLayout()
                castCollectionView.collectionViewLayout.prepare()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myScrollView.delegate = self
        porterImgView.layer.cornerRadius = 10
        titleLBL.text = mTitle
        averajeLBL.text = mAverage
        releaseDateLBL.text = mReleaseDate
        porterImgView.image = mPosterImage
        backdropImgView.image = mBackdropImage
        overviewTxtView.text = mOverview
        overviewTxtView.sizeToFit()
        
        castCollectionView.dataSource = self
        watchTrailerBTN.layer.cornerRadius = 20
        
        checkIfIsFav()
        checkMovieStoryline()
        checkMovieGenres()
        checkIfNotRataed()
        checkIfNotHasReleaseDate()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navSetting()
    }
    
    fileprivate func checkIfIsFav() {
        let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", mID)
        do{
            let result = try PersistanceService.context.fetch(request)
            if result.count > 0{
                self.isFavorite = true
                self.watchTrailerBTN.setImage(UIImage(named: "heartOn"), for: .normal)
            }else{
                self.isFavorite = false
                self.watchTrailerBTN.setImage(UIImage(named: "heartOff"), for: .normal)
            }
        }catch{}
    }
    
    fileprivate func checkMovieStoryline() {
        if mOverview == ""{
            storylineLBL.text = "No Story found"
        }
    }
    
    fileprivate func checkMovieGenres() {
        if mGenres == []{
            genresView.removeFromSuperview()
        }else{
            for item in mGenres{
                let key = item as! Int
                addGenreLabelView(forText: genresDic[key]!)
            }
        }
    }
    
    fileprivate func checkIfNotRataed() {
        if averajeLBL.text == "0"{
            averajeLBL.isHidden = true
            ratingLBL.isHidden = true
            
            let notRatingLBL = UILabel()
            notRatingLBL.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            notRatingLBL.textColor = UIColor.gray
            notRatingLBL.text = "Not rated"
            notRatingLBL.numberOfLines = 0
            notRatingLBL.setContentHuggingPriority(.defaultLow, for: .vertical)
            notRatingLBL.setContentCompressionResistancePriority(.required, for: .vertical)
            notRatingLBL.minimumScaleFactor = 1
            notRatingLBL.adjustsFontSizeToFitWidth = true
            
            ratingStackView.addArrangedSubview(notRatingLBL)
        }
    }
    
    fileprivate func checkIfNotHasReleaseDate() {
        if releaseDateLBL.text == ""{
            releaseDateLBL.isHidden = true
            releaseDateTextLBL.isHidden = true
            
            let releaseDateUnknownLBL = UILabel()
            releaseDateUnknownLBL.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            releaseDateUnknownLBL.textColor = UIColor.gray
            releaseDateUnknownLBL.text = "Release date unknown"
            releaseDateUnknownLBL.numberOfLines = 0
            releaseDateUnknownLBL.setContentHuggingPriority(.defaultLow, for: .vertical)
            releaseDateUnknownLBL.setContentCompressionResistancePriority(.required, for: .vertical)
            releaseDateUnknownLBL.minimumScaleFactor = 1
            releaseDateUnknownLBL.adjustsFontSizeToFitWidth = true
            
            releaseDateStackView.addArrangedSubview(releaseDateUnknownLBL)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        navigationController?.navigationBar.tintColor = .gray
        var colors = [UIColor]()
        colors.append(UIColor.rgb(red: 249, green: 249, blue: 249, alpha: 1))
        colors.append(UIColor.rgb(red: 249, green: 249, blue: 249, alpha: 1))
        navigationController?.navigationBar.setGradientBackground(colors: colors)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    override func viewDidLayoutSubviews() {
        myCollectionViewHeight = castCollectionView.bounds.size.height
    }
    
    func navSetting(){
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        shareBTN = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(DetailViewController.shareBtnAction))
        self.navigationItem.rightBarButtonItem = shareBTN
    }
    
    func setupView(){
        isMovieFromDB = false
        guard let movie = movieToDetail else { return print("There is no movie to details") }
        mTitle = movie.title
        mID = movie.movieID
        mAverage = movie.averageScore
        mOverview = movie.overview
        mGenres = movie.genres
        mReleaseDate = movie.releaseDate
        movie.delegate = self
        movie.getPosterImage()
        movie.getBackdropImage()
        movie.getTrailerKey()
        if movie.credits.isEmpty{
            castLabelString = "Loading Cast..."
            movie.getCreditsArr()
        }else{
            mCredits = movie.credits
        }
        
        print("Genres IDs: \(String(describing: movie.genres))")
        
    }
    
    func setupViewFromDB(){
        isMovieFromDB = true
        guard let movie = movieToDetailFromDB else { return print("There is no movie to details") }
        mTitle = movie.title!
        mID = movie.id!
        mAverage = movie.score!
        mOverview = movie.overview!
        mGenres = movie.genres!
        mReleaseDate = movie.releaseDate!
        mPosterImage = UIImage(data: (movieToDetailFromDB?.poster as Data?)!)
        mBackdropImage = UIImage(data: (movieToDetailFromDB?.backdrop as Data?)!)
        
        let request:NSFetchRequest<CastEntity> = CastEntity.fetchRequest()
        request.predicate = NSPredicate(format: "castMovieRelation == %@", movieToDetailFromDB!)
        do{
            let results = try PersistanceService.context.fetch(request)
            if results.count > 0{
                mCredits2 = results
            }
        }catch{}
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
            guard let placeholderStackView = genresView.arrangedSubviews.last else {return}
            placeholderStackView.removeFromSuperview()
            let newRowStackView = getNewRowStackView()
            newRowStackView.addArrangedSubview(label)
            genresView.addArrangedSubview(newRowStackView)
            isFirstGenreLoad = false
        }else{
            let lastRowStackView = genresView.arrangedSubviews.last as! UIStackView
            lastRowStackView.layoutIfNeeded()
            if (lastRowStackView.frame.width + label.intrinsicContentSize.width) < genresView.frame.width{
                lastRowStackView.addArrangedSubview(label)
                genresView.addArrangedSubview(lastRowStackView)
            }else{
                let newRowStackView = getNewRowStackView()
                newRowStackView.addArrangedSubview(label)
                genresView.addArrangedSubview(newRowStackView)
            }
        }
        
    }
    
    @objc func shareBtnAction(){
        guard let trailer = URL(string: "http://www.youtube.com/watch?v=\(trailerKey)") else {return}
        let activityVC = UIActivityViewController(activityItems: [trailer], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func watchTrailerFunc(_ sender: Any) {
//        guard let url = URL(string: "http://www.youtube.com/watch?v=\(trailerKey)") else {return}
//         UIApplication.shared.open(url, options: [:], completionHandler: { (finish) in
//
//         })
        if isFavorite{
            let request: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", mID)
            do{
                let result = try PersistanceService.context.fetch(request)
                if result.count > 0{
                    let movieToBeDeleted = result[0]
                    PersistanceService.context.delete(movieToBeDeleted)
                    PersistanceService.saveContext()
                    isFavorite = false
                    self.watchTrailerBTN.setImage(UIImage(named: "heartOff"), for: .normal)
                }
            }catch{}
            
        }else{
            let myMovie = MovieEntity(context: PersistanceService.context)
            myMovie.title = mTitle
            myMovie.score = mAverage
            myMovie.releaseDate = mReleaseDate
            myMovie.id = mID
            myMovie.overview = mOverview
            if mGenres != []{
                myMovie.genres = mGenres
            }
            if !mCredits.isEmpty{
                for cast in mCredits{
                    let myCast = CastEntity(context: PersistanceService.context)
                    myCast.name = cast.name
                    myCast.character = cast.character
                    myCast.photo = UIImagePNGRepresentation(cast.photo) as NSData?
                    myCast.castMovieRelation = myMovie
                }
            }
            myMovie.poster = UIImagePNGRepresentation(porterImgView.image!) as NSData?
            myMovie.backdrop = UIImagePNGRepresentation(backdropImgView.image!) as NSData?
            PersistanceService.saveContext()
            isFavorite = true
            self.watchTrailerBTN.setImage(UIImage(named: "heartOn"), for: .normal)
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - MovieDataDownloadDelegate
    func posterDownloadComplete(image:UIImage){
        porterImgView.image = image
    }
    
    func backdropDownloadComplete(image:UIImage){
        backdropImgView.image = image
    }
    
    func trailerKeyDownloadComplete(key:String){
        if key == ""{
            watchTrailerBTN.isHidden = true
        }else{
           trailerKey = key
        }
    }
    func castDownloadComplete(success:Bool){
        if success{
            guard let movie = movieToDetail else { return print("There is no movie to details") }
            castLabelString = "The Cast"
            mCredits = movie.credits
            castCollectionView.reloadData()
        }else{
            mCredits = [Cast]()
            castLabelString = "No Cast found"
        }
        
    }
    
    // ScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let offset = scrollView.contentOffset.y
        var headerTransform = CATransform3DIdentity
        
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / backdropImgView.bounds.height
            let headerSizevariation = ((backdropImgView.bounds.height * (1.0 + headerScaleFactor)) - backdropImgView.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            
            backdropImgView.layer.transform = headerTransform
        }else{
            headerTransform = CATransform3DTranslate(headerTransform, 0, -offset, 0)
        }
        
        backdropImgView.layer.transform = headerTransform
    }
    
    /* Cast CollectionView */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if isMovieFromDB{
            return mCredits2.count
        }else{
            return mCredits.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if isMovieFromDB{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "castCell", for: indexPath) as! CastCollectionViewCell
            let currentCast = mCredits2[indexPath.row]
            var castPhoto = UIImage()
            if let data = currentCast.photo{
                if let photo = UIImage(data: data as Data){
                    castPhoto = photo
                }else{
                    castPhoto = UIImage(named: "placeholderCastImage")!
                }
            }else{
                castPhoto = UIImage(named: "placeholderCastImage")!
            }
            cell.setupCell2(withMovie: currentCast, andImage: castPhoto)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "castCell", for: indexPath) as! CastCollectionViewCell
            cell.setupCell(credits: mCredits[indexPath.row])
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: 90, height: myCollectionViewHeight)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
