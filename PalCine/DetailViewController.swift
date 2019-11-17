//
//  DetailViewController.swift
//  PalCine
//
//  Created by Oscar Santos on 7/3/17.
//  Copyright © 2017 Oscar Santos. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: RootViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, NavigationBarReporting{
    
    var showNavBarBG: Bool = false
    var navTintColor: UIColor = UIColor.white
    
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
    let webservice = WebService.sharedInstance
    let netNotificationView = NetNotificationView.sharedInstance
    var dataSource:MyCollectionViewDataSource<CastCollectionViewCell,CastViewModel>!
    
    var trailerKey = ""
    var mGenres:NSArray = []
    var isFavorite = false
    var maxCornerRadius:CGFloat = 0
    var navBarHeight:CGFloat = 0
    
    var viewsToAnimate = [UIView]()
    var anim:Animations!
    
    var castLabelString: String = "" {
        didSet{
            guard let castLabel = theCastLBL else {return}
            castLabel.text = castLabelString
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        curveShapeView.drawShape()
        if let barBG = navigationController?.navigationBar.subviews.first{
            self.navBarHeight = barBG.frame.height
        }
        navigationController?.navigationBar.tintColor = navTintColor
        //navigationItem.backBarButtonItem?.tintColor = navTintColor
        titleBgView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, size: CGSize.init(width: self.view.frame.width, height: navBarHeight))
        backdropContainerView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, size: CGSize.init(width: self.view.frame.width, height: navBarHeight))
        backdropImgView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, size: CGSize.init(width: self.view.frame.width, height: 200))
        backdropFxView.anchor(top: self.view.topAnchor, leading: self.view.leadingAnchor, bottom: nil, trailing: self.view.trailingAnchor, size: CGSize.init(width: self.view.frame.width, height: 200))
        myScrollView.delegate = self
        castCollectionView.delegate = self
        castCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        porterImgView.layer.shadowColor = UIColor(named: "MOSshadow")?.cgColor
        porterImgView.layer.shadowOpacity = 0.7
        porterImgView.layer.shadowOffset = CGSize.zero
        porterImgView.layer.shadowRadius = 10
        porterImgView.layer.shadowPath = UIBezierPath(rect: porterImgView.bounds).cgPath
        porterImgView.layer.shouldRasterize = true
        
        heartBTN.layer.cornerRadius = 20
        heartBTN.isEnabled = false
        titleBgView.layer.zPosition = 3
        backdropFxView.alpha = 0
        
        titleBgView.setGradientBG(colors: [UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 0.6), UIColor.clear])
        
        setPlaceholderAnimations()
        setObservers()
        
        detailViewModel = DetailViewModel(movie: movieToDetail!, completion: { [weak self] in
            DispatchQueue.main.async{
                self?.setUpView()
            }
        })
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func animate() {
        guard let coordinator = self.transitionCoordinator else {
            return
        }
        coordinator.animate(alongsideTransition: {
            [weak self] context in
            self?.navigationController?.navigationBar.tintColor = self?.navTintColor
            self?.navigationItem.backBarButtonItem?.tintColor = self?.navTintColor
            self?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: self?.navTintColor ?? UIColor.white]
        }, completion: nil)
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
            mGenres = detailViewModel.genres
            self.genresView.populate(with: self.mGenres)
        }
        
        if detailViewModel.credits.isEmpty{
            castLabelString = NSLocalizedString("No Cast found", comment: "No Cast found in the movie")
        }else{
            castLabelString = NSLocalizedString("The Cast", comment: "The Cast in the movie")
            
            self.dataSource = MyCollectionViewDataSource(cellIdentifier: "castCell", items: detailViewModel.credits, configureCell: { (cell, vm) in
                cell.setupCell(credits: vm)
                self.anim.stopLoading(views: [cell.castImageView,cell.castName,cell.castCharacter])
            })
            castCollectionView.dataSource = self.dataSource
            castCollectionView.heightAnchor.constraint(equalToConstant: castCollectionView.contentSize.height).isActive = true
        }
        
        if isFavorite{
            self.heartBTN.setImage(UIImage(named: "heartOn"), for: .normal)
        }else{
            self.heartBTN.setImage(UIImage(named: "heartOff"), for: .normal)
        }
        self.heartBTN.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navSetting()
        if !webservice.isConnectedToInternet{
            lostConnection()
        }
        animate()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func navSetting(){
        if shareBTN == nil{
            shareBTN = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(DetailViewController.shareBtnAction))
            self.navigationItem.rightBarButtonItem = shareBTN
        }
    }
    //MARK: NavigationBar functions
    override func setNavigationColors(){
        self.preferredStatusBarStyle = UIStatusBarStyle.lightContent
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection){
                porterImgView.layer.shadowColor = UIColor(named: "MOSshadow")?.cgColor
                porterImgView.layer.shadowOpacity = 0.7
                porterImgView.layer.shadowOffset = CGSize.zero
                porterImgView.layer.shadowRadius = 10
                porterImgView.layer.shadowPath = UIBezierPath(rect: porterImgView.bounds).cgPath
                curveShapeView.drawShape()
            }
        }
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
        heartBTN.isUserInteractionEnabled = false
    }
    @objc func findConnection(){
        detailViewModel = DetailViewModel(movie: movieToDetail!, completion: { [weak self] in
            DispatchQueue.main.async{
                self?.setUpView()
            }
        })
        netNotificationView.dismissNetNotificationView(onView: self.view)
        heartBTN.isUserInteractionEnabled = true
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
        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { (finish) in

        })
    }
}

extension DetailViewController: UIScrollViewDelegate{
    // MARK: ScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let offset = scrollView.contentOffset.y
        let offset_HeaderStop:CGFloat = navBarHeight == 64 ? 75 : 50
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
            
            curveShapeView.animateShape(value: offset, offsetStop: offset_HeaderStop)
            backdropBlurFxAnimation(value: offset, offsetStop: offset_HeaderStop)
            backdropImgView.layer.transform = headerTransform
        }
    }
    
    func backdropBlurFxAnimation(value:CGFloat, offsetStop:CGFloat){
        let positiveVal = value < 0 ? 0 : value
        let offsetPos = positiveVal > offsetStop ? 1 : positiveVal / offsetStop
        let reverse = (offsetPos - 1) * -1
        titleBgView.alpha = reverse
        backdropFxView.alpha = offsetPos
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
