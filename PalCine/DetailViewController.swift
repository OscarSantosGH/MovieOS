//
//  DetailViewController.swift
//  PalCine
//
//  Created by Oscar Santos on 7/3/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: RootViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var backdropImgView: UIImageView!
    @IBOutlet weak var porterImgView: UIImageView!
    @IBOutlet weak var titleLBL: UILabel!
    @IBOutlet weak var averajeLBL: UILabel!
    @IBOutlet weak var overviewTxtView: UITextView!
    @IBOutlet weak var titleBgView: UIView!
    @IBOutlet weak var heartBTN: UIButton!
    @IBOutlet weak var genresView: GenderTagStackVIew!
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
    
    var shareBTN:UIBarButtonItem?
    var movieToDetail:Movie?
    var detailViewModel:DetailViewModel!
    var webservice:WebService!
    var netNotificationView:NetNotificationView!
    var dataSource:MyCollectionViewDataSource<CastCollectionViewCell,CastViewModel>!
    
    var trailerKey = ""
    var mGenres:NSArray = []
    var isFavorite = false
    var maxCornerRadius:CGFloat = 0
    
    var viewsToAnimate = [UIView]()
    var anim:Animations!
    
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
        castCollectionView.delegate = self
        castCollectionView.translatesAutoresizingMaskIntoConstraints = false
        webservice = WebService.sharedInstance
        netNotificationView = NetNotificationView.sharedInstance
        
        porterImgView.layer.shadowColor = UIColor.black.cgColor
        porterImgView.layer.shadowOpacity = 0.7
        porterImgView.layer.shadowOffset = CGSize.zero
        porterImgView.layer.shadowRadius = 10
        porterImgView.layer.shadowPath = UIBezierPath(rect: porterImgView.bounds).cgPath
        porterImgView.layer.shouldRasterize = true
        
        heartBTN.layer.cornerRadius = 20
        titleBgView.layer.zPosition = 3
        backdropFxView.alpha = 0
        
        titleBgView.setGradientBG(colors: [UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 0.6), UIColor.clear])
        
        setPlaceholderAnimations()
        setObservers()
        
        detailViewModel = DetailViewModel(movie: movieToDetail!, completion: {
            DispatchQueue.main.async{
                self.setUpView()
            }
        })
        
    }
    
    private func setPlaceholderAnimations(){
        self.anim = Animations.shareInstance
        viewsToAnimate = [titleLBL,ratingStackView,releaseDateStackView,genresView,overviewTxtView.textInputView,backdropImgView,porterImgView,theCastLBL,storylineLBL]
        anim.startLoading(views: viewsToAnimate)
        var placeholderCast = [CastViewModel]()
        for _ in 1...10 {
            let emptyCast = CastViewModel(name: "", character: "", imageUrl: "")
            placeholderCast.append(emptyCast)
        }
        self.dataSource = MyCollectionViewDataSource(cellIdentifier: "castCell", items: placeholderCast, configureCell: { (cell, vm) in
            cell.makeItPlaceholder()
        })
        castCollectionView.dataSource = self.dataSource
    }
    
    private func setUpView(){
        anim.stopLoading(views: viewsToAnimate)
        detailViewModel.movieDelegate = self
        titleLBL.text = detailViewModel.title
        averajeLBL.text = detailViewModel.averaje
        releaseDateLBL.text = detailViewModel.releaseDate
        porterImgView.image = detailViewModel.posterImg
        backdropImgView.image = detailViewModel.backdropImg
        overviewTxtView.text = detailViewModel.overview
        overviewTxtView.sizeToFit()
        
        isFavorite = detailViewModel.isFavorite
        
        if averajeLBL.text == "0"{
            averajeLBL.isHidden = true
            ratingLBL.isHidden = true
            ratingStackView.addArrangedSubview(detailViewModel.notRatingLBL)
        }
        
        if releaseDateLBL.text == ""{
            releaseDateLBL.isHidden = true
            releaseDateTextLBL.isHidden = true
            releaseDateStackView.addArrangedSubview(detailViewModel.releaseDateUnknownLBL)
        }
        
        if detailViewModel.genres != []{
            print(detailViewModel.genres)
            mGenres = detailViewModel.genres
            self.genresView.populate(with: self.mGenres)
        }
        
        if detailViewModel.credits.isEmpty{
            castLabelString = "No Cast found"
        }else{
            castLabelString = "The Cast"
            
            self.dataSource = MyCollectionViewDataSource(cellIdentifier: "castCell", items: detailViewModel.credits, configureCell: { (cell, vm) in
                cell.setupCell(credits: vm)
                self.anim.stopLoading(views: [cell.castImageView,cell.castName,cell.castCharacter])
            })
            castCollectionView.dataSource = self.dataSource
            
        }
        
        if isFavorite{
            self.heartBTN.setImage(UIImage(named: "heartOn"), for: .normal)
        }else{
            self.heartBTN.setImage(UIImage(named: "heartOff"), for: .normal)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navSetting()
        navigationController?.setNavigationBarHidden(false, animated: true)
        if !webservice.isConnectedToInternet{
            lostConnection()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         print("collectionview content height: \(castCollectionView.contentSize.height)")
        castCollectionView.heightAnchor.constraint(equalToConstant: castCollectionView.contentSize.height).isActive = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.tintColor = .gray
//        var colors = [UIColor]()
//        colors.append(UIColor.rgb(red: 249, green: 249, blue: 249, alpha: 1))
//        colors.append(UIColor.rgb(red: 249, green: 249, blue: 249, alpha: 1))
//        navigationController?.navigationBar.setGradientBackground(colors: colors)
//        navigationController?.navigationBar.shadowImage = UIImage()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    override func viewDidLayoutSubviews() {
        myCollectionViewHeight = castCollectionView.bounds.size.height
    }
    
    func navSetting(){
//        navigationController?.navigationBar.backgroundColor = .clear
//        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        shareBTN = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(DetailViewController.shareBtnAction))
        self.navigationItem.rightBarButtonItem = shareBTN
    }
    //MARK: NavigationBar functions
    override func setNavigationColors(){
        //navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        //navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        guard let barBG = navigationController?.navigationBar.subviews.first else {return}
        guard let barBGfx = barBG.subviews.last else {return}
        barBGfx.alpha = 0
//        for v in barBG.subviews{
//            if v.tag == 800{
//                v.backgroundColor = UIColor.clear
//            }
//        }
        self.preferredStatusBarStyle = UIStatusBarStyle.lightContent
    }
    
    //MARK: Notifications
    func setObservers(){
        let hasInternetNotificationName = Notification.Name(rawValue: "com.oscarsantos.hasInternet")
        let notInternetNotificationName = Notification.Name(rawValue: "com.oscarsantos.notInternet")
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.findConnection), name: hasInternetNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.lostConnection), name: notInternetNotificationName, object: nil)
    }
    @objc func lostConnection(){
        netNotificationView.presentNetNotificationView(onView: self.view)
    }
    @objc func findConnection(){
        detailViewModel = DetailViewModel(movie: movieToDetail!, completion: {
            DispatchQueue.main.async{
                self.setUpView()
            }
        })
        netNotificationView.dismissNetNotificationView(onView: self.view)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func shareBtnAction(){
        guard let trailer = URL(string: "http://www.youtube.com/watch?v=\(trailerKey)") else {return}
        let activityVC = UIActivityViewController(activityItems: [trailer], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func watchTrailerFunc(_ sender: Any) {
        if isFavorite{
            PersistanceService.deleteMovie(movie: movieToDetail!) { (success) in
                if success{
                    self.isFavorite = false
                    self.heartBTN.setImage(UIImage(named: "heartOff"), for: .normal)
                }
            }

        }else{
            self.movieToDetail?.backdropImg = self.backdropImgView.image!
            self.movieToDetail?.credits.removeAll()
            for c in detailViewModel.credits{
                let cast = c.convertToCast()
                self.movieToDetail?.credits.append(cast)
            }
            PersistanceService.saveMovie(movie: movieToDetail!) {
                self.isFavorite = true
                self.heartBTN.setImage(UIImage(named: "heartOn"), for: .normal)
                self.anim.heartBeat(view: self.heartBTN)
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width / 2) - 16, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

}

extension DetailViewController: movieImageDownloadDelegate{
    
    func backdropDownloadComplete(image:UIImage){
        self.backdropImgView.image = image
    }
    
    func trailerKeyDownloadComplete(key:String){
        if key == ""{
            
        }else{
            trailerKey = key
            porterImgView.insertPlayBtn()
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.playTrailerPress))
            porterImgView.addGestureRecognizer(gesture)
        }
    }
    
    @objc func playTrailerPress(sender : UITapGestureRecognizer){
        guard let url = URL(string: "http://www.youtube.com/watch?v=\(trailerKey)") else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: { (finish) in

        })
    }
}

extension DetailViewController: UIScrollViewDelegate{
    // MARK: ScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let offset = scrollView.contentOffset.y
        let offset_HeaderStop:CGFloat = 75
        var headerTransform = CATransform3DIdentity
        let headerScaleFactor:CGFloat = -(offset) / backdropImgView.bounds.height
        let headerSizevariation = ((backdropImgView.bounds.height * (1.0 + headerScaleFactor)) - backdropImgView.bounds.height)/2.0
        
        if offset != 0.0{
            if offset < 0 {
                headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
                headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
            }else{
                headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offset_HeaderStop, -offset), 0)
            }
            
            if offset <= offset_HeaderStop {
                if myScrollView.layer.zPosition < backdropContainerView.layer.zPosition{
                    backdropContainerView.layer.zPosition = 0
                    backdropContainerView.clipsToBounds = false
                }
            }else {
                if myScrollView.layer.zPosition >= backdropContainerView.layer.zPosition{
                    backdropContainerView.layer.zPosition = 1
                    backdropContainerView.clipsToBounds = true
                }
            }
            
            curveShapeView.animateShape(value: offset)
            backdropBlurFxAnimation(value: offset)
            backdropImgView.layer.transform = headerTransform
        }
        
    }
    
    func backdropBlurFxAnimation(value:CGFloat){
        let positiveVal = value < 0 ? 0 : value
        let offsetPos = positiveVal > 75 ? 1 : positiveVal / 75
        let reverse = (offsetPos - 1) * -1
        titleBgView.alpha = reverse
        backdropFxView.alpha = offsetPos
    }
}
